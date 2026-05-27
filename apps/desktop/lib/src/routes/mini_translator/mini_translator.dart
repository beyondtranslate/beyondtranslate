// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:protocol_handler/protocol_handler.dart';

import '../../extensions/window_controller.dart';
import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../routes/settings/general.dart' show GeneralSettingsPage;
import '../../services/llm_stream.dart';
import '../../services/mac_settings.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../services/shortcut_service/shortcut_service.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../widgets/ui/button.dart';
import '../app_router.dart'
    show
        miniTranslatorPositionBelowTray,
        miniTranslatorWindowController,
        showSettingsWindow;
import 'limited_functionality_banner.dart';
import 'translation_input_view.dart';
import 'translation_results_view.dart';
import 'translation_target_select_view.dart';

class MiniTranslatorPage extends StatefulWidget {
  const MiniTranslatorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MiniTranslatorPageState();
}

class _MiniTranslatorPageState extends State<MiniTranslatorPage>
    with WidgetsBindingObserver, ProtocolListener, ShortcutListener {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _bannersViewKey = GlobalKey();
  final GlobalKey _inputViewKey = GlobalKey();
  final GlobalKey _resultsViewKey = GlobalKey();
  final GlobalKey _toolbarViewKey = GlobalKey();

  Brightness _brightness = Brightness.light;

  Offset _lastShownPosition = Offset.zero;

  // The mini-translator grows with its content but caps at this height, after
  // which the results area scrolls.
  static const double _maxWindowHeight = 800;

  bool _isAlwaysOnTop = false;

  bool _isAllowedScreenCaptureAccess = true;
  bool _isAllowedScreenSelectionAccess = true;

  String _sourceLanguage = kAutoSource;
  String? _selectedTargetLanguage;
  int _activeConfigIndex = -1;
  List<TranslationTarget> _fastTargets = [];

  bool _querySubmitted = false;
  String _text = '';
  String? _detectedLanguage;
  bool _isTextDetecting = false;
  List<TranslationResult> _translationResultList = [];

  Timer? _resizeSettledTimer;
  bool _isWindowResizeScheduled = false;
  bool _pendingWindowResizeAnimate = true;
  bool _pendingWindowResizeSettle = false;
  int? _windowFocusedListenerId;
  int? _windowBlurredListenerId;
  int? _windowMovedListenerId;

  nativeapi.Window get _window => miniTranslatorWindowController.window;

  @override
  void initState() {
    settingsStore.addListener(_handleChanged);
    WidgetsBinding.instance.addObserver(this);
    if (kIsLinux || kIsMacOS || kIsWindows) {
      protocolHandler.addListener(this);
      ShortcutService.instance.setListener(this);
      _registerWindowEvents();
      _init();
    }
    _loadData();
    super.initState();
    _scheduleWindowResize(
      animate: false,
      settle: true,
    );
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    WidgetsBinding.instance.removeObserver(this);
    if (kIsLinux || kIsMacOS || kIsWindows) {
      protocolHandler.removeListener(this);
      ShortcutService.instance.setListener(null);
      _unregisterWindowEvents();
      _uninit();
    }
    _resizeSettledTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    Brightness newBrightness =
        WidgetsBinding.instance.window.platformBrightness;

    if (newBrightness != _brightness) {
      _setStateAndScheduleWindowResize(() {
        _brightness = newBrightness;
      });
    }
  }

  void _handleChanged() {
    _setStateAndScheduleWindowResize(() {});
  }

  void _setStateAndScheduleWindowResize(
    VoidCallback fn, {
    bool animate = true,
  }) {
    if (!mounted) return;
    setState(fn);
    _scheduleWindowResize(animate: animate);
  }

  void _init() async {
    if (kIsMacOS) {
      _isAllowedScreenCaptureAccess =
          await runtime.permission().isScreenRecordingPermissionGranted();
      _isAllowedScreenSelectionAccess =
          await runtime.permission().isAccessibilityPermissionGranted();
    }

    ShortcutService.instance.start();

    await Future.delayed(const Duration(milliseconds: 100));
    if (kIsLinux || kIsWindows) {
      final primaryDisplay = nativeapi.DisplayManager.instance.getPrimary();
      if (primaryDisplay != null) {
        final windowSize = _window.size;
        _lastShownPosition = Offset(
          primaryDisplay.size.width - windowSize.width - 50,
          50,
        );
      }
      _window.setPosition(_lastShownPosition.dx, _lastShownPosition.dy);
    } else if (kIsMacOS) {
      final position = miniTranslatorPositionBelowTray(
        windowSize: _window.size,
      );
      if (position != null) {
        _lastShownPosition = position;
        _window.setPosition(position.dx, position.dy);
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
    await _windowShow(
      isShowBelowTray: kIsMacOS,
    );
    _setStateAndScheduleWindowResize(() {});
  }

  void _registerWindowEvents() {
    _windowFocusedListenerId = nativeapi.WindowManager.instance
        .on<nativeapi.WindowFocusedEvent>((event) {
      if (event.windowId == _window.id) {
        _focusNode.requestFocus();
      }
    });
    _windowBlurredListenerId = nativeapi.WindowManager.instance
        .on<nativeapi.WindowBlurredEvent>((event) {
      if (event.windowId == _window.id) {
        _focusNode.unfocus();
        if (!_window.isAlwaysOnTop) {
          _window.hide();
        }
      }
    });
    _windowMovedListenerId = nativeapi.WindowManager.instance
        .on<nativeapi.WindowMovedEvent>((event) {
      if (event.windowId == _window.id) {
        _lastShownPosition = event.position;
      }
    });
  }

  void _unregisterWindowEvents() {
    if (_windowFocusedListenerId != null) {
      nativeapi.WindowManager.instance.off(_windowFocusedListenerId!);
      _windowFocusedListenerId = null;
    }
    if (_windowBlurredListenerId != null) {
      nativeapi.WindowManager.instance.off(_windowBlurredListenerId!);
      _windowBlurredListenerId = null;
    }
    if (_windowMovedListenerId != null) {
      nativeapi.WindowManager.instance.off(_windowMovedListenerId!);
      _windowMovedListenerId = null;
    }
  }

  void _uninit() {
    ShortcutService.instance.stop();
  }

  Future<void> _windowShow({
    bool isShowBelowTray = false,
  }) async {
    final isAlwaysOnTop = _window.isAlwaysOnTop;
    // final windowSize = _window.size;

    if (kIsLinux) {
      _window.setPosition(_lastShownPosition.dx, _lastShownPosition.dy);
    }

    // if (kIsMacOS && isShowBelowTray) {
    //   final trayIconBounds = _trayIcon?.bounds;
    //   if (trayIconBounds != null) {
    //     final trayIconSize = trayIconBounds.size;
    //     final trayIconPosition = trayIconBounds.topLeft;

    //     Offset newPosition = Offset(
    //       trayIconPosition.dx - ((windowSize.width - trayIconSize.width) / 2),
    //       trayIconPosition.dy,
    //     );

    //     if (!isAlwaysOnTop) {
    //       _window.setPosition(newPosition.dx, newPosition.dy);
    //     }
    //   }
    // }

    final isVisible = _window.isVisible;
    if (!isVisible) {
      _window.show();
    } else {
      _window.focus();
    }
    _scheduleWindowResize(
      animate: false,
      settle: true,
    );

    if (kIsLinux && !isAlwaysOnTop) {
      _window.isAlwaysOnTop = true;
      await Future.delayed(const Duration(milliseconds: 10));
      _window.isAlwaysOnTop = false;
      await Future.delayed(const Duration(milliseconds: 10));
      _window.focus();
    }
  }

  Future<void> _windowHide() async {
    _window.hide();
  }

  void _scheduleWindowResize({
    bool animate = true,
    bool settle = false,
  }) {
    if (!(kIsLinux || kIsMacOS || kIsWindows)) return;

    _pendingWindowResizeAnimate = _isWindowResizeScheduled
        ? _pendingWindowResizeAnimate && animate
        : animate;
    _pendingWindowResizeSettle = _pendingWindowResizeSettle || settle;
    if (_isWindowResizeScheduled) return;

    _isWindowResizeScheduled = true;
    WidgetsBinding.instance.endOfFrame.then((_) {
      _isWindowResizeScheduled = false;
      final pendingAnimate = _pendingWindowResizeAnimate;
      final pendingSettle = _pendingWindowResizeSettle;
      _pendingWindowResizeAnimate = true;
      _pendingWindowResizeSettle = false;

      if (!mounted) return;
      _windowResize(animate: pendingAnimate);
      if (pendingSettle) {
        _scheduleSettledWindowResize(animate: pendingAnimate);
      }
    });
  }

  void _windowResize({
    bool animate = true,
  }) {
    if (context.canPop()) return;

    try {
      final oldSize = _window.size;
      final newHeight = _measureWindowHeight();
      final newSize = Size(
        oldSize.width,
        newHeight.clamp(0, _maxWindowHeight),
      );
      if (oldSize.width == newSize.width && oldSize.height == newSize.height) {
        return;
      }
      _window.setSize(
        newSize.width,
        newSize.height,
        animate: animate,
      );
    } catch (error) {
      // ignore
    }
  }

  double _measureWindowHeight() {
    final toolbarViewHeight = _renderBoxHeight(_toolbarViewKey);
    final bannersViewHeight = _renderBoxHeight(_bannersViewKey);
    final inputViewHeight = _renderBoxHeight(_inputViewKey);
    final resultsViewHeight = _renderBoxHeight(_resultsViewKey);

    return toolbarViewHeight +
        bannersViewHeight +
        inputViewHeight +
        resultsViewHeight +
        (kIsWindows ? 5 : 0);
  }

  double _renderBoxHeight(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }

  void _scheduleSettledWindowResize({
    bool animate = true,
  }) {
    _resizeSettledTimer?.cancel();
    _resizeSettledTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      _windowResize(animate: animate);
      _resizeSettledTimer = null;
    });
  }

  void _loadData() async {
    // The previous implementation populated `_latestVersion` from a cloud API
    // and refreshed local engine config. Both pieces of state moved into the
    // Rust runtime / external installers, so the mini translator no longer
    // performs network bootstrapping here.
  }

  Future<void> _queryData() async {
    setState(() {
      _querySubmitted = true;
      _detectedLanguage = null;
      _translationResultList = [];
    });

    final settings = runtime.settings();
    final providers = await settings.listProviders();
    final generalSettings = await settings.getGeneral();

    // Detect source language for translation target matching.
    if (_text.isNotEmpty) {
      try {
        final translationProvider = providers.firstWhere(
          (p) => p.capabilities.contains(ProviderCapability.translation),
        );
        final detectResponse = await runtime
            .translation(providerId: translationProvider.id)
            .detectLanguage(
              request: DetectLanguageRequest(texts: [_text]),
            );
        final detections = detectResponse.detections;
        if (detections != null && detections.isNotEmpty) {
          _detectedLanguage = detections.first.detectedLanguage;
          if (mounted) {
            _setStateAndScheduleWindowResize(() {});
          }
        }
      } catch (e) {
        // Detection failed silently; continue without detected language
        debugPrint('Language detection failed: $e');
      }
    }

    final activeTargets = await _activeTranslationTargets(generalSettings);
    final nextTranslationResultList =
        _createPendingTranslationResults(activeTargets, providers);

    _setStateAndScheduleWindowResize(
      () {
        _translationResultList = nextTranslationResultList;
      },
      animate: false,
    );

    final futures = <Future<bool>>[];
    for (int i = 0; i < _translationResultList.length; i++) {
      final translationTarget = _translationResultList[i].translationTarget;
      final translationResultRecordList =
          _translationResultList[i].translationResultRecordList;
      if (translationResultRecordList == null) {
        continue;
      }

      for (int j = 0; j < translationResultRecordList.length; j++) {
        futures.add(_queryProvider(
          provider: providers[j],
          translationTarget: translationTarget,
          translationResultRecord: translationResultRecordList[j],
        ));
      }
    }

    await Future.wait(futures);
  }

  List<TranslationResult> _createPendingTranslationResults(
    List<TranslationTarget> activeTargets,
    List<ProviderConfigEntry> providers,
  ) {
    return [
      for (final translationTarget in activeTargets)
        TranslationResult(
          translationTarget: translationTarget,
          translationResultRecordList: [
            for (final provider in providers)
              TranslationResultRecord(
                translationEngineId: provider.id,
              ),
          ],
          unsupportedEngineIdList: [],
        ),
    ];
  }

  Future<bool> _queryProvider({
    required ProviderConfigEntry provider,
    required TranslationTarget? translationTarget,
    required TranslationResultRecord translationResultRecord,
  }) async {
    final sourceLanguage = translationTarget?.source;
    final targetLanguage = translationTarget?.target;
    final futures = <Future<void>>[];

    if (provider.capabilities.contains(ProviderCapability.dictionary)) {
      futures.add(() async {
        try {
          if (sourceLanguage == null || targetLanguage == null) {
            throw Exception('Translation target language is missing');
          }

          final lookUpRequest = LookUpRequest(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            word: _text,
          );
          final lookUpResponse = await runtime
              .dictionary(providerId: provider.id)
              .lookup(request: lookUpRequest);
          translationResultRecord.lookUpRequest = lookUpRequest;
          translationResultRecord.lookUpResponse = lookUpResponse;
        } catch (error) {
          translationResultRecord.lookUpError = TranslationError(
            message: error.toString(),
          );
        }
        if (mounted) _setStateAndScheduleWindowResize(() {});
      }());
    }

    if (provider.capabilities.contains(ProviderCapability.translation)) {
      final isLlmProvider = provider.type == ProviderType.openAi ||
          provider.type == ProviderType.anthropic ||
          provider.type == ProviderType.ollama;

      if (isLlmProvider) {
        // Streaming LLM translation — update UI progressively
        futures.add(() async {
          try {
            final translateRequest = TranslateRequest(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              text: _text,
            );
            translationResultRecord.translateRequest = translateRequest;

            final buffer = StringBuffer();
            final stream = LlmStream.translate(
              providerId: provider.id,
              sourceLang: sourceLanguage ?? 'auto',
              targetLang: targetLanguage ?? 'en',
              text: _text,
            );

            await for (final chunk in stream) {
              if (chunk.content.isNotEmpty) {
                buffer.write(chunk.content);
                // Update the record with accumulated text so far
                translationResultRecord.translateResponse = TranslateResponse(
                  translations: [
                    TextTranslation(
                      text: buffer.toString(),
                      detectedSourceLanguage: null,
                      audioUrl: null,
                    ),
                  ],
                );
                if (mounted) {
                  _setStateAndScheduleWindowResize(() {});
                }
              }
            }
          } catch (error) {
            translationResultRecord.translateError = TranslationError(
              message: error.toString(),
            );
            if (mounted) _setStateAndScheduleWindowResize(() {});
          }
        }());
      } else {
        // Traditional non-streaming translation
        futures.add(() async {
          try {
            final translateRequest = TranslateRequest(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              text: _text,
            );
            final translateResponse = await runtime
                .translation(providerId: provider.id)
                .translate(request: translateRequest);
            translationResultRecord.translateRequest = translateRequest;
            translationResultRecord.translateResponse = translateResponse;
          } catch (error) {
            translationResultRecord.translateError = TranslationError(
              message: error.toString(),
            );
          }
        }());
      }
    }

    await Future.wait(futures);

    if (mounted) {
      _setStateAndScheduleWindowResize(() {});
    }
    return true;
  }

  Future<List<TranslationTarget>> _activeTranslationTargets(
    GeneralSettings generalSettings,
  ) async {
    final persistentTargets = generalSettings.translationTargets;

    if (_activeConfigIndex >= 0 &&
        _activeConfigIndex < persistentTargets.length) {
      return [persistentTargets[_activeConfigIndex]];
    }

    if (_selectedTargetLanguage != null) {
      return _fastTargets.isNotEmpty
          ? _fastTargets
          : [
              TranslationTarget(
                source: _sourceLanguage,
                target: _selectedTargetLanguage!,
                enabled: true,
              ),
            ];
    }

    if (persistentTargets.isNotEmpty) {
      final settings = runtime.settings();
      return await settings.getActiveTranslationTargets(
        targets: persistentTargets,
        detectedLanguage: _detectedLanguage,
      );
    }

    return [
      TranslationTarget(
        source: _sourceLanguage,
        target: defaultTargetLanguage,
        enabled: true,
      ),
    ];
  }

  void _handleSourceChanged(String newSource) {
    _setStateAndScheduleWindowResize(() {
      _sourceLanguage = newSource;
      _activeConfigIndex = -1;
      if (_selectedTargetLanguage != null) {
        _fastTargets = [
          TranslationTarget(
            source: newSource,
            target: _selectedTargetLanguage!,
            enabled: true,
          ),
        ];
      }
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleTargetLanguageChanged(String? targetCode) {
    _setStateAndScheduleWindowResize(() {
      _selectedTargetLanguage = targetCode;
      _activeConfigIndex = -1;
      _fastTargets = targetCode == null
          ? []
          : [
              TranslationTarget(
                source: _sourceLanguage,
                target: targetCode,
                enabled: true,
              ),
            ];
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleConfigTargetSelected(int index) {
    if (index == -1) {
      _setStateAndScheduleWindowResize(() {
        _activeConfigIndex = -1;
        _sourceLanguage = kAutoSource;
        _selectedTargetLanguage = null;
        _fastTargets = [];
      });
      if (_text.isNotEmpty) _handleButtonTappedTrans();
      return;
    }
    final target = settingsStore.general.translationTargets[index];
    _setStateAndScheduleWindowResize(() {
      _activeConfigIndex = index;
      _sourceLanguage = target.source;
      _selectedTargetLanguage = target.target;
      _fastTargets = [];
    });
    if (_text.isNotEmpty) _handleButtonTappedTrans();
  }

  void _handleManageTargets() {
    showSettingsWindow();
  }

  void _handleManageCommonLanguages() {
    if (kIsMacOS) {
      MacSettings.showAndOpenCommonLanguages();
    } else {
      showSettingsWindow();
      GeneralSettingsPage.pendingOpenCommonLanguages = true;
    }
  }

  void _handleAddTarget() {
    if (kIsMacOS) {
      MacSettings.showAndOpenAddTarget();
    } else {
      showSettingsWindow();
      GeneralSettingsPage.pendingOpenAddTarget = true;
    }
  }

  void _handleTextChanged(
    String? newValue, {
    bool isRequery = false,
  }) {
    _setStateAndScheduleWindowResize(() {
      _text = (newValue ?? '').trim();
      if (settingsStore.inputSubmitMode == InputSubmitMode.enter) {
        _text = _text.replaceAll('\n', ' ');
      }
    });
    if (isRequery) {
      _textEditingController.text = _text;
      _textEditingController.selection = TextSelection(
        baseOffset: _text.length,
        extentOffset: _text.length,
      );
      _handleButtonTappedTrans();
    }
  }

  void _handleExtractTextFromScreenSelection() async {
    String? text;
    try {
      text = await runtime.textExtractor().extractFromScreenSelection();
    } catch (_) {
      // extractFromScreenSelection may throw if no text is selected or
      // operation fails (e.g. accessibility not granted on macOS).
    }

    await _windowShow();
    await Future.delayed(const Duration(milliseconds: 10));

    _handleTextChanged(text, isRequery: true);
  }

  void _handleExtractTextFromScreenCapture() async {
    _setStateAndScheduleWindowResize(() {
      _querySubmitted = false;
      _text = '';
      _detectedLanguage = null;
      _isTextDetecting = false;
      _translationResultList = [];
    });
    _textEditingController.clear();
    _focusNode.unfocus();

    await _windowHide();

    try {
      final text = await runtime.textExtractor().extractFromScreenCapture();
      await _windowShow();
      _handleTextChanged(text, isRequery: true);
    } catch (error) {
      await _windowShow();
      _setStateAndScheduleWindowResize(() {});
      BotToast.showText(
        text:
            '${t.mini_translator.message.ocr_recognition_failed}: ${error.toString()}',
        align: Alignment.center,
      );
    }
  }

  void _handleExtractTextFromClipboard() async {
    final windowIsVisible = _window.isVisible;
    if (!windowIsVisible) {
      await _windowShow();
      await Future.delayed(const Duration(milliseconds: 10));
    }

    String? text;
    try {
      text = await runtime.textExtractor().extractFromClipboard();
    } catch (_) {
      // extractFromClipboard may throw if clipboard is empty.
    }
    _handleTextChanged(text, isRequery: true);
  }

  void _handleButtonTappedClear() {
    _setStateAndScheduleWindowResize(() {
      _querySubmitted = false;
      _text = '';
      _detectedLanguage = null;
      _isTextDetecting = false;
      _translationResultList = [];
    });
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  void _handleButtonTappedTrans() async {
    if (_text.isEmpty) {
      BotToast.showText(
        text: t.mini_translator.message.please_enter_word_or_text,
        align: Alignment.center,
      );
      _focusNode.requestFocus();
      return;
    }
    await _queryData();
  }

  Widget _buildBannersView(BuildContext context) {
    bool isNoAllowedAllAccess =
        !(_isAllowedScreenCaptureAccess && _isAllowedScreenSelectionAccess);

    return Container(
      key: _bannersViewKey,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: isNoAllowedAllAccess ? 8 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNoAllowedAllAccess)
            LimitedFunctionalityBanner(
              isAllowedScreenCaptureAccess: _isAllowedScreenCaptureAccess,
              isAllowedScreenSelectionAccess: _isAllowedScreenSelectionAccess,
              onTappedRecheckIsAllowedAllAccess: () async {
                _isAllowedScreenCaptureAccess = await runtime
                    .permission()
                    .isScreenRecordingPermissionGranted();
                _isAllowedScreenSelectionAccess = await runtime
                    .permission()
                    .isAccessibilityPermissionGranted();

                _setStateAndScheduleWindowResize(() {});

                if (_isAllowedScreenCaptureAccess &&
                    _isAllowedScreenSelectionAccess) {
                  BotToast.showText(
                    text: t.mini_translator.limited_banner.feedback.enabled,
                    align: Alignment.center,
                  );
                } else {
                  BotToast.showText(
                    text:
                        t.mini_translator.limited_banner.feedback.still_missing,
                    align: Alignment.center,
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInputView(BuildContext context) {
    return SizedBox(
      key: _inputViewKey,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TranslationInputView(
            focusNode: _focusNode,
            controller: _textEditingController,
            onChanged: (newValue) => _handleTextChanged(newValue),
            isTextDetecting: _isTextDetecting,
            inputSubmitMode: settingsStore.inputSubmitMode,
            onClickExtractTextFromScreenCapture:
                _handleExtractTextFromScreenCapture,
            onClickExtractTextFromClipboard: _handleExtractTextFromClipboard,
            onButtonTappedClear: _handleButtonTappedClear,
            onButtonTappedTrans: _handleButtonTappedTrans,
          ),
          const SizedBox(height: 8),
          TranslationTargetSelectView(
            sourceLanguage: _sourceLanguage,
            selectedTargetLanguage: _selectedTargetLanguage,
            activeConfigIndex: _activeConfigIndex,
            persistentTargets: settingsStore.general.translationTargets,
            commonLanguageCodes: settingsStore.general.commonLanguages,
            onSourceChanged: _handleSourceChanged,
            onTargetLanguageChanged: _handleTargetLanguageChanged,
            onConfigTargetSelected: _handleConfigTargetSelected,
            onManageTargets: _handleManageTargets,
            onManageCommonLanguages: _handleManageCommonLanguages,
            onAddTarget: _handleAddTarget,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context) {
    return TranslationResultsView(
      viewKey: _resultsViewKey,
      controller: _scrollController,
      querySubmitted: _querySubmitted,
      text: _text,
      textDetectedLanguage: _detectedLanguage,
      translationResultList: _translationResultList,
      onTextTapped: (word) {
        _handleTextChanged(word, isRequery: true);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                ),
                child: SingleChildScrollView(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBannersView(context),
                      _buildInputView(context),
                    ],
                  ),
                ),
              ),
              _buildResultsView(context),
            ],
          ),
        );
      },
    );
  }

  /// macOS 26 style inline toolbar — integrated into the window chrome area
  Widget _buildToolBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: _toolbarViewKey,
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // macOS-style traffic light area simulation via spacing
          SizedBox(
            width: 52,
            height: 24,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _isAlwaysOnTop
                        ? theme.colorScheme.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Button(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _isAlwaysOnTop = !_isAlwaysOnTop;
                      });
                      _window.isAlwaysOnTop = _isAlwaysOnTop;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      transformAlignment: Alignment.center,
                      transform: Matrix4.rotationZ(
                        _isAlwaysOnTop ? 0 : -0.78,
                      ),
                      child: Icon(
                        _isAlwaysOnTop
                            ? FluentIcons.pin_20_filled
                            : FluentIcons.pin_20_regular,
                        size: 18,
                        color: _isAlwaysOnTop
                            ? theme.colorScheme.primary
                            : theme.iconTheme.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // macOS 26 style: center area kept empty for a clean, floating look
          const Spacer(),
          SizedBox(
            width: 52,
            height: 24,
            child: Align(
              alignment: Alignment.centerRight,
              child: Button(
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: () {
                  showSettingsWindow();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FluentIcons.settings_20_regular,
                    size: 18,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToolBar(context),
          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  @override
  void onProtocolUrlReceived(String url) async {
    Uri uri = Uri.parse(url);
    if (uri.scheme != 'beyondtranslate') return;

    if (uri.authority == 'translate') {
      if (_text.isNotEmpty) _handleButtonTappedClear();
      String? text = uri.queryParameters['text'];
      if (text != null && text.isNotEmpty) {
        _handleTextChanged(text, isRequery: true);
      }
    }
    await _windowShow();
  }

  @override
  void onShortcutKeyDownToggleMiniTranslator() async {
    final isVisible = _window.isVisible;
    if (isVisible) {
      _windowHide();
    } else {
      _windowShow();
    }
  }

  @override
  void onShortcutKeyDownExtractFromScreenSelection() {
    _handleExtractTextFromScreenSelection();
  }

  @override
  void onShortcutKeyDownExtractFromScreenCapture() {
    _handleExtractTextFromScreenCapture();
  }

  @override
  void onShortcutKeyDownExtractFromClipboard() {
    _handleExtractTextFromClipboard();
  }

  @override
  void onShortcutKeyDownSubmitWithMateEnter() {
    if (settingsStore.inputSubmitMode != InputSubmitMode.commandEnter) {
      return;
    }
    _handleButtonTappedTrans();
  }

  @override
  void onShortcutKeyDownTranslateInputContent() {
    // TODO: Reimplement when keypress_simulator dependency is restored
  }
}
