// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:protocol_handler/protocol_handler.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';

import '../../../main.dart' show mainWindowController;
import '../../extensions/window_controller.dart';

import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../models/translation_target.dart';
import '../../rust/domain/settings.dart' as rust_settings;
import '../../services/native_settings.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../services/shortcut_service/shortcut_service.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/button.dart';
import 'limited_functionality_banner.dart';
import 'mini_translator_app.dart' show miniTranslatorWindowController;
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

  Brightness _brightness = Brightness.light;

  String? _lastAppLanguage;
  Offset _lastShownPosition = Offset.zero;

  // The mini-translator window has a fixed maximum height. The previous
  // implementation made this user-configurable but the runtime no longer
  // models such a preference, mirroring the macOS Swift implementation.
  static const double _maxWindowHeight = 800;

  bool _isAlwaysOnTop = false;

  bool _isAllowedScreenCaptureAccess = true;
  bool _isAllowedScreenSelectionAccess = true;

  String _sourceLanguage = kLanguageEN;
  String _targetLanguage = kLanguageZH;
  bool _isShowSourceLanguageSelector = false;
  bool _isShowTargetLanguageSelector = false;

  bool _querySubmitted = false;
  String _text = '';
  String? _textDetectedLanguage;
  CapturedData? _capturedData;
  bool _isTextDetecting = false;
  List<TranslationResult> _translationResultList = [];

  List<Future> _futureList = [];

  Timer? _resizeTimer;
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
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    Brightness newBrightness =
        WidgetsBinding.instance.window.platformBrightness;

    if (newBrightness != _brightness) {
      _brightness = newBrightness;
      setState(() {});
    }
  }

  void _handleChanged() {
    _lastAppLanguage = settingsStore.appLanguage;

    if (mounted) setState(() {});
  }

  void _init() async {
    if (kIsMacOS) {
      _isAllowedScreenCaptureAccess =
          await ScreenCapturer.instance.isAccessAllowed();
      _isAllowedScreenSelectionAccess =
          await screenTextExtractor.isAccessAllowed();
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
    }
    await Future.delayed(const Duration(milliseconds: 100));
    await _windowShow(
      isShowBelowTray: kIsMacOS,
    );
    setState(() {});
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
    final windowSize = _window.size;

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

  void _windowResize() {
    if (context.canPop()) return;

    if (_resizeTimer != null && _resizeTimer!.isActive) {
      _resizeTimer?.cancel();
    }
    _resizeTimer = Timer.periodic(const Duration(milliseconds: 10), (_) async {
      if (!kIsMacOS) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      RenderBox? rb1 =
          _bannersViewKey.currentContext?.findRenderObject() as RenderBox?;
      RenderBox? rb2 =
          _inputViewKey.currentContext?.findRenderObject() as RenderBox?;
      RenderBox? rb3 =
          _resultsViewKey.currentContext?.findRenderObject() as RenderBox?;

      double toolbarViewHeight = 36.0;
      double bannersViewHeight = rb1?.size.height ?? 0;
      double inputViewHeight = rb2?.size.height ?? 0;
      double resultsViewHeight = rb3?.size.height ?? 0;

      try {
        double newWindowHeight = toolbarViewHeight +
            bannersViewHeight +
            inputViewHeight +
            resultsViewHeight +
            (kIsWindows ? 5 : 0);
        final oldSize = _window.size;
        Size newSize = Size(
          oldSize.width,
          newWindowHeight < _maxWindowHeight
              ? newWindowHeight
              : _maxWindowHeight,
        );
        if (oldSize.width != newSize.width ||
            oldSize.height != newSize.height) {
          _window.setSize(newSize.width, newSize.height, animate: true);
        }
      } catch (error) {
        // ignore
      }

      if (_resizeTimer != null) {
        _resizeTimer?.cancel();
        _resizeTimer = null;
      }
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
      _isShowSourceLanguageSelector = false;
      _isShowTargetLanguageSelector = false;
      _querySubmitted = true;
      _textDetectedLanguage = null;
      _translationResultList = [];
      _futureList = [];
    });

    // Load providers and translation targets from runtime settings.
    final settings = runtime.settings();
    final providers = await settings.listProviders();
    final generalSettings = await settings.getGeneral();

    final translationMode = generalSettings.translationMode;

    List<TranslationTarget> activeTargets;
    if (translationMode == rust_settings.TranslationMode.manual) {
      activeTargets = [
        TranslationTarget(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        ),
      ];
    } else {
      // Map domain TranslationTarget to app model TranslationTarget.
      activeTargets = generalSettings.translationTargets
          .map((t) => TranslationTarget(
                sourceLanguage: t.source,
                targetLanguage: t.target,
              ))
          .toList();
    }

    for (var translationTarget in activeTargets) {
      TranslationResult translationResult = TranslationResult(
        translationTarget: translationTarget,
        translationResultRecordList: [],
        unsupportedEngineIdList: [],
      );
      _translationResultList.add(translationResult);
    }
    setState(() {});

    for (int i = 0; i < _translationResultList.length; i++) {
      final translationTarget = _translationResultList[i].translationTarget;
      final translationResultRecordList =
          _translationResultList[i].translationResultRecordList;
      if (translationResultRecordList == null) {
        continue;
      }

      for (final provider in providers) {
        String identifier = provider.id;
        List<String> capabilities = provider.capabilities;

        TranslationResultRecord translationResultRecord =
            TranslationResultRecord(
          translationEngineId: identifier,
          translationTargetId: translationTarget?.id,
        );
        translationResultRecordList.add(translationResultRecord);

        Future<bool> future = Future<bool>.sync(() async {
          final sourceLanguage = translationTarget?.sourceLanguage;
          final targetLanguage = translationTarget?.targetLanguage;

          // Dictionary lookup
          if (capabilities.contains(ProviderCapability.dictionary.name)) {
            try {
              if (sourceLanguage == null || targetLanguage == null) {
                throw Exception('Translation target language is missing');
              }

              final lookUpRequest = LookUpRequest(
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                word: _text,
              );
              final lookUpResponse =
                  await runtime.dictionary(identifier).lookup(lookUpRequest);
              translationResultRecord.lookUpRequest = lookUpRequest;
              translationResultRecord.lookUpResponse = lookUpResponse;
            } catch (error) {
              translationResultRecord.lookUpError = TranslationError(
                message: error.toString(),
              );
            }
          }

          // Translation
          if (capabilities.contains(ProviderCapability.translation.name)) {
            try {
              final translateRequest = TranslateRequest(
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                text: _text,
              );
              final translateResponse = await runtime
                  .translation(identifier)
                  .translate(translateRequest);
              translationResultRecord.translateRequest = translateRequest;
              translationResultRecord.translateResponse = translateResponse;
            } catch (error) {
              translationResultRecord.translateError = TranslationError(
                message: error.toString(),
              );
            }
          }

          if (mounted) {
            setState(() {});
          }
          return true;
        });
        _futureList.add(future);
      }
    }

    await Future.wait(_futureList);
  }

  void _handleTextChanged(
    String? newValue, {
    bool isRequery = false,
  }) {
    setState(() {
      _text = (newValue ?? '').trim();
      if (settingsStore.inputSubmitMode ==
          rust_settings.InputSubmitMode.enter) {
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
    ExtractedData? extractedData = await screenTextExtractor.extract(
      mode: ExtractMode.screenSelection,
    );

    await _windowShow();
    await Future.delayed(const Duration(milliseconds: 10));

    _handleTextChanged(extractedData?.text, isRequery: true);
  }

  void _handleExtractTextFromScreenCapture() async {
    setState(() {
      _querySubmitted = false;
      _text = '';
      _textDetectedLanguage = null;
      _capturedData = null;
      _isTextDetecting = false;
      _translationResultList = [];
    });
    _textEditingController.clear();
    _focusNode.unfocus();

    await _windowHide();

    String? imagePath;
    if (!kIsWeb) {
      Directory dataDirectory = await getAppDataDirectory();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName = 'Screenshot-$timestamp.png';
      imagePath = '${dataDirectory.path}/Screenshots/$fileName';
    }
    _capturedData = await ScreenCapturer.instance.capture(
      imagePath: imagePath,
    );

    await _windowShow();

    if (_capturedData == null) {
      BotToast.showText(
        text: t.mini_translator.msg_capture_screen_area_canceled,
        align: Alignment.center,
      );
      setState(() {});
      return;
    } else {
      // OCR was previously performed by the in-app `uni_ocr_client`. The
      // Rust runtime has not yet exposed a generic OCR endpoint, so for now we
      // surface a toast to indicate the action is unsupported. The captured
      // image is still stored on disk for future processing.
      _isTextDetecting = false;
      setState(() {});
      BotToast.showText(
        text: 'Text extraction service is not configured.',
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

    ExtractedData? extractedData = await screenTextExtractor.extract(
      mode: ExtractMode.clipboard,
    );
    _handleTextChanged(extractedData?.text, isRequery: true);
  }

  void _handleButtonTappedClear() {
    setState(() {
      _querySubmitted = false;
      _text = '';
      _textDetectedLanguage = null;
      _capturedData = null;
      _isTextDetecting = false;
      _translationResultList = [];
    });
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  void _handleButtonTappedTrans() async {
    if (_text.isEmpty) {
      BotToast.showText(
        text: t.mini_translator.msg_please_enter_word_or_text,
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
        bottom: isNoAllowedAllAccess ? 12 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNoAllowedAllAccess)
            LimitedFunctionalityBanner(
              isAllowedScreenCaptureAccess: _isAllowedScreenCaptureAccess,
              isAllowedScreenSelectionAccess: _isAllowedScreenSelectionAccess,
              onTappedRecheckIsAllowedAllAccess: () async {
                _isAllowedScreenCaptureAccess =
                    await ScreenCapturer.instance.isAccessAllowed();
                _isAllowedScreenSelectionAccess =
                    await screenTextExtractor.isAccessAllowed();

                setState(() {});

                if (_isAllowedScreenCaptureAccess &&
                    _isAllowedScreenSelectionAccess) {
                  BotToast.showText(
                    text:
                        t.mini_translator.limited_banner_msg_all_access_allowed,
                    align: Alignment.center,
                  );
                } else {
                  BotToast.showText(
                    text: t.mini_translator
                        .limited_banner_msg_all_access_not_allowed,
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
            capturedData: _capturedData,
            isTextDetecting: _isTextDetecting,
            translationMode: settingsStore.translationMode,
            onTranslationModeChanged: (_) {
              // Persisted by SettingsStore; rebuild on notify.
            },
            inputSubmitMode: settingsStore.inputSubmitMode,
            onClickExtractTextFromScreenCapture:
                _handleExtractTextFromScreenCapture,
            onClickExtractTextFromClipboard: _handleExtractTextFromClipboard,
            onButtonTappedClear: _handleButtonTappedClear,
            onButtonTappedTrans: _handleButtonTappedTrans,
          ),
          TranslationTargetSelectView(
            translationMode: settingsStore.translationMode,
            isShowSourceLanguageSelector: _isShowSourceLanguageSelector,
            isShowTargetLanguageSelector: _isShowTargetLanguageSelector,
            onToggleShowSourceLanguageSelector: (newValue) {
              setState(() {
                _isShowSourceLanguageSelector = newValue;
                _isShowTargetLanguageSelector = false;
              });
            },
            onToggleShowTargetLanguageSelector: (newValue) {
              setState(() {
                _isShowSourceLanguageSelector = false;
                _isShowTargetLanguageSelector = newValue;
              });
            },
            sourceLanguage: _sourceLanguage,
            targetLanguage: _targetLanguage,
            onChanged: (newSourceLanguage, newTargetLanguage) {
              setState(() {
                _isShowSourceLanguageSelector = false;
                _isShowTargetLanguageSelector = false;
                _sourceLanguage = newSourceLanguage;
                _targetLanguage = newTargetLanguage;
              });
              if (_text.isNotEmpty) {
                _handleButtonTappedTrans();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context) {
    return TranslationResultsView(
      viewKey: _resultsViewKey,
      controller: _scrollController,
      translationMode: settingsStore.translationMode,
      querySubmitted: _querySubmitted,
      text: _text,
      textDetectedLanguage: _textDetectedLanguage,
      translationResultList: _translationResultList,
      onTextTapped: (word) {
        _handleTextChanged(word, isRequery: true);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildBannersView(context),
          _buildInputView(context),
          _buildResultsView(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildToolBar(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Button(
              onPressed: () {
                setState(() {
                  _isAlwaysOnTop = !_isAlwaysOnTop;
                });
                mainWindowController.window.isAlwaysOnTop = _isAlwaysOnTop;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  _isAlwaysOnTop ? 0 : -0.8,
                ),
                child: Icon(
                  _isAlwaysOnTop
                      ? FluentIcons.pin_20_filled
                      : FluentIcons.pin_20_regular,
                  color: _isAlwaysOnTop ? theme.colorScheme.primary : null,
                ),
              ),
            ),
            Expanded(child: Container()),
            Button(
              onPressed: () {
                if (Platform.isMacOS) {
                  NativeSettings.show();
                  return;
                }

                mainWindowController.window.show();
              },
              child: const Icon(FluentIcons.settings_20_regular),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildToolBar(context),
      body: _buildBody(context),
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
  void onShortcutKeyDownShowOrHide() async {
    final isVisible = _window.isVisible;
    if (isVisible) {
      _windowHide();
    } else {
      _windowShow();
    }
  }

  @override
  void onShortcutKeyDownHide() async {
    _windowHide();
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
    if (settingsStore.inputSubmitMode !=
        rust_settings.InputSubmitMode.commandEnter) {
      return;
    }
    _handleButtonTappedTrans();
  }

  List<ModifierKey> get _commandModifiers {
    final modifier =
        kIsMacOS ? ModifierKey.metaModifier : ModifierKey.controlModifier;
    return [modifier];
  }

  @override
  void onShortcutKeyDownTranslateInputContent() async {
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyA,
      _commandModifiers,
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyA,
      _commandModifiers,
    );

    try {
      ExtractedData? extractedData = await screenTextExtractor.extract(
        mode: ExtractMode.screenSelection,
      );

      if ((extractedData?.text ?? '').isEmpty) {
        throw Exception('Extracted text is empty');
      }

      final settings = runtime.settings();
      final generalSettings = await settings.getGeneral();
      final providerId = generalSettings.defaultTranslationService;

      TranslateResponse translateResponse =
          await runtime.translation(providerId).translate(
                TranslateRequest(
                  text: extractedData?.text ?? '',
                  sourceLanguage: kLanguageZH,
                  targetLanguage: kLanguageEN,
                ),
              );

      TextTranslation? textTranslation =
          translateResponse.translations.firstOrNull;

      if (textTranslation != null) {
        Clipboard.setData(ClipboardData(text: textTranslation.text));
      }
    } catch (error) {
      return;
    }

    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyA,
      _commandModifiers,
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyA,
      _commandModifiers,
    );
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyV,
      _commandModifiers,
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyV,
      _commandModifiers,
    );
  }
}
