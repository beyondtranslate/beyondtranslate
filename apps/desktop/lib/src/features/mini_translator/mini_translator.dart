// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:protocol_handler/protocol_handler.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';
import 'package:shortid/shortid.dart';
import 'package:uni_ocr_client/uni_ocr_client.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

import '../../i18n/i18n.dart';
import '../../models/preference_item.dart';
import '../../models/translation_engine_config.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../models/translation_target.dart';
import '../../models/version.dart';
import '../../networking/api_client/api_client.dart';
import '../../networking/ocr_client/ocr_client.dart';
import '../../networking/translate_client/translate_client.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../services/native_settings.dart';
import '../../services/shortcut_service/shortcut_service.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/button.dart';
import '../../windowing/window_controllers.dart';
import 'limited_functionality_banner.dart';
import 'new_version_found_banner.dart';
import 'translation_input_view.dart';
import 'translation_results_view.dart';
import 'translation_target_select_view.dart';

const kMenuItemKeyShow = 'show';
const kMenuItemKeyQuickStartGuide = 'quick-start-guide';
const kMenuItemKeyQuitApp = 'quit-app';

const kMenuSubItemKeyJoinDiscord = 'subitem-join-discord';
const kMenuSubItemKeyJoinQQGroup = 'subitem-join-qq';

class ToolbarItemAlwaysOnTop extends StatefulWidget {
  const ToolbarItemAlwaysOnTop({Key? key}) : super(key: key);

  @override
  State<ToolbarItemAlwaysOnTop> createState() => _ToolbarItemAlwaysOnTopState();
}

class _ToolbarItemAlwaysOnTopState extends State<ToolbarItemAlwaysOnTop> {
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _isAlwaysOnTop = miniTranslatorWindowController.window.isAlwaysOnTop;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Button(
        padding: EdgeInsets.zero,
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
            size: 20,
            color: _isAlwaysOnTop
                ? Theme.of(context).primaryColor
                : Theme.of(context).iconTheme.color,
          ),
        ),
        onPressed: () {
          setState(() {
            _isAlwaysOnTop = !_isAlwaysOnTop;
          });
          miniTranslatorWindowController.window.isAlwaysOnTop = _isAlwaysOnTop;
        },
      ),
    );
  }
}

class ToolbarItemSettings extends StatelessWidget {
  const ToolbarItemSettings({
    Key? key,
    required this.onSubPageDismissed,
  }) : super(key: key);

  final VoidCallback onSubPageDismissed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Button(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        child: Icon(
          FluentIcons.settings_20_regular,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          if (Platform.isMacOS) {
            await NativeSettings.show();
            onSubPageDismissed();
            // return;
          }

          final mainWindow = mainWindowController.window;
          mainWindow.show();
          mainWindow.focus();
          await Future.delayed(const Duration(milliseconds: 200));
          onSubPageDismissed();
        },
      ),
    );
  }
}

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

  Configuration get _configuration => localDb.configuration;

  Brightness _brightness = Brightness.light;

  bool? _lastShowTrayIcon;
  String? _lastAppLanguage;
  Offset _lastShownPosition = Offset.zero;

  Version? _latestVersion;
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
  nativeapi.TrayIcon? _trayIcon;
  nativeapi.Image? _trayIconImage;
  final List<nativeapi.Menu> _trayMenus = <nativeapi.Menu>[];
  final List<nativeapi.MenuItem> _trayMenuItems = <nativeapi.MenuItem>[];

  List<TranslationEngineConfig> get _translationEngineList {
    return localDb.engines.list(
      where: (e) => !e.disabled,
    );
  }

  List<TranslationTarget> get _translationTargetList {
    if (_configuration.translationMode == kTranslationModeManual) {
      return [
        TranslationTarget(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        ),
      ];
    }
    return localDb.translationTargets.list();
  }

  nativeapi.Window get _window => miniTranslatorWindowController.window;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
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
    localDb.preferences.removeListener(_handleChanged);
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
      if (kIsWindows && _configuration.showTrayIcon) {
        _initTrayIcon();
      }
      setState(() {});
    }
  }

  void _handleChanged() {
    bool trayIconUpdated = _lastShowTrayIcon != _configuration.showTrayIcon ||
        _lastAppLanguage != _configuration.appLanguage;

    _lastShowTrayIcon = _configuration.showTrayIcon;
    _lastAppLanguage = _configuration.appLanguage;

    if (trayIconUpdated) {
      _initTrayIcon();
    }

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

    await _initTrayIcon();
    await Future.delayed(const Duration(milliseconds: 100));
    if (kIsLinux || kIsWindows) {
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final windowSize = _window.size;
      _lastShownPosition = Offset(
        primaryDisplay.size.width - windowSize.width - 50,
        50,
      );
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

  Future<void> _initTrayIcon() async {
    if (kIsWeb) return;

    String trayIconName = 'tray_icon_black.png';
    if (_brightness == Brightness.dark) {
      trayIconName = 'tray_icon.png';
    }

    _destroyTrayIcon();
    if (!_configuration.showTrayIcon ||
        !nativeapi.TrayManager.instance.isSupported) {
      return;
    }

    _trayIcon = nativeapi.TrayIcon();
    _trayIconImage =
        nativeapi.Image.fromAsset('resources/images/$trayIconName');
    if (_trayIconImage != null) {
      _trayIcon!.icon = _trayIconImage;
    }
    _trayIcon!.contextMenuTrigger = nativeapi.ContextMenuTrigger.none;
    _trayIcon!.on<nativeapi.TrayIconClickedEvent>((event) {
      _handleTrayIconMouseDown();
    });
    _trayIcon!.on<nativeapi.TrayIconRightClickedEvent>((event) {
      _handleTrayIconRightMouseDown();
    });
    _trayIcon!.contextMenu = _buildTrayMenu();
    _trayIcon!.isVisible = true;
  }

  nativeapi.Menu _buildTrayMenu() {
    final menu = nativeapi.Menu();
    _trayMenus.add(menu);

    final versionItem = nativeapi.MenuItem(
      '${t.app_name} v${sharedEnv.appVersion} (BUILD ${sharedEnv.appBuildNumber})',
    );
    versionItem.enabled = false;
    _trayMenuItems.add(versionItem);
    menu.addItem(versionItem);
    menu.addSeparator();

    if (kIsLinux) {
      final showItem = nativeapi.MenuItem(t.tray_context_menu.item_show);
      showItem.on<nativeapi.MenuItemClickedEvent>((event) {
        _handleTrayMenuItemClick(kMenuItemKeyShow);
      });
      _trayMenuItems.add(showItem);
      menu.addItem(showItem);
    }

    final quickStartGuideItem =
        nativeapi.MenuItem(t.tray_context_menu.item_quick_start_guide);
    quickStartGuideItem.on<nativeapi.MenuItemClickedEvent>((event) {
      _handleTrayMenuItemClick(kMenuItemKeyQuickStartGuide);
    });
    _trayMenuItems.add(quickStartGuideItem);
    menu.addItem(quickStartGuideItem);

    final discussionMenu = nativeapi.Menu();
    _trayMenus.add(discussionMenu);

    final joinDiscordItem = nativeapi.MenuItem(
      t.tray_context_menu.item_discussion_subitem_discord_server,
    );
    joinDiscordItem.on<nativeapi.MenuItemClickedEvent>((event) {
      _handleTrayMenuItemClick(kMenuSubItemKeyJoinDiscord);
    });
    _trayMenuItems.add(joinDiscordItem);
    discussionMenu.addItem(joinDiscordItem);

    final joinQQGroupItem = nativeapi.MenuItem(
      t.tray_context_menu.item_discussion_subitem_qq_group,
    );
    joinQQGroupItem.on<nativeapi.MenuItemClickedEvent>((event) {
      _handleTrayMenuItemClick(kMenuSubItemKeyJoinQQGroup);
    });
    _trayMenuItems.add(joinQQGroupItem);
    discussionMenu.addItem(joinQQGroupItem);

    final discussionItem = nativeapi.MenuItem(
      t.tray_context_menu.item_discussion,
      nativeapi.MenuItemType.submenu,
    );
    discussionItem.submenu = discussionMenu;
    _trayMenuItems.add(discussionItem);
    menu.addItem(discussionItem);

    menu.addSeparator();

    final quitItem = nativeapi.MenuItem(t.tray_context_menu.item_quit_app);
    quitItem.on<nativeapi.MenuItemClickedEvent>((event) {
      _handleTrayMenuItemClick(kMenuItemKeyQuitApp);
    });
    _trayMenuItems.add(quitItem);
    menu.addItem(quitItem);

    return menu;
  }

  void _destroyTrayIcon() {
    _trayIcon?.dispose();
    _trayIcon = null;

    for (final item in _trayMenuItems) {
      item.dispose();
    }
    _trayMenuItems.clear();

    for (final menu in _trayMenus) {
      menu.dispose();
    }
    _trayMenus.clear();

    _trayIconImage?.dispose();
    _trayIconImage = null;
  }

  void _uninit() {
    ShortcutService.instance.stop();
    _destroyTrayIcon();
  }

  Future<void> _windowShow({
    bool isShowBelowTray = false,
  }) async {
    final isAlwaysOnTop = _window.isAlwaysOnTop;
    final windowSize = _window.size;

    if (kIsLinux) {
      _window.setPosition(_lastShownPosition.dx, _lastShownPosition.dy);
    }

    if (kIsMacOS && isShowBelowTray) {
      final trayIconBounds = _trayIcon?.bounds;
      if (trayIconBounds != null) {
        final trayIconSize = trayIconBounds.size;
        final trayIconPosition = trayIconBounds.topLeft;

        Offset newPosition = Offset(
          trayIconPosition.dx - ((windowSize.width - trayIconSize.width) / 2),
          trayIconPosition.dy,
        );

        if (!isAlwaysOnTop) {
          _window.setPosition(newPosition.dx, newPosition.dy);
        }
      }
    }

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
          newWindowHeight < _configuration.maxWindowHeight
              ? newWindowHeight
              : _configuration.maxWindowHeight,
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
    try {
      _latestVersion = await apiClient.version('latest').get();
      setState(() {});
    } catch (error) {
      // skip
    }
    try {
      await localDb.loadFromCloudServer();
    } catch (error) {
      // skip
    }
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

    if (_configuration.translationMode == kTranslationModeManual) {
      TranslationResult translationResult = TranslationResult(
        translationTarget: _translationTargetList.first,
        translationResultRecordList: [],
      );
      _translationResultList = [translationResult];
    } else {
      var filteredTranslationTargetList = _translationTargetList;
      try {
        DetectLanguageRequest detectLanguageRequest = DetectLanguageRequest(
          texts: [_text],
        );
        DetectLanguageResponse detectLanguageResponse = await translateClient
            .use(_configuration.defaultEngineId ?? '')
            .detectLanguage(detectLanguageRequest);

        _textDetectedLanguage = detectLanguageResponse
            .detections!.first.detectedLanguage
            .split('-')[0];

        filteredTranslationTargetList = _translationTargetList
            .where((e) => e.sourceLanguage == _textDetectedLanguage)
            .toList();
      } catch (error) {
        // ignore
      }

      for (var translationTarget in filteredTranslationTargetList) {
        TranslationResult translationResult = TranslationResult(
          translationTarget: translationTarget,
          translationResultRecordList: [],
          unsupportedEngineIdList: [],
        );
        _translationResultList.add(translationResult);
      }

      setState(() {});
    }

    for (int i = 0; i < _translationResultList.length; i++) {
      TranslationTarget? translationTarget =
          _translationResultList[i].translationTarget;

      List<String> engineIdList = [];
      List<String> unsupportedEngineIdList = [];

      for (int j = 0; j < _translationEngineList.length; j++) {
        String identifier = _translationEngineList[j].identifier;

        if (_translationEngineList[j].disabled) continue;

        try {
          List<LanguagePair> supportedLanguagePairList = [];
          supportedLanguagePairList =
              await translateClient.use(identifier).getSupportedLanguagePairs();

          LanguagePair? languagePair =
              supportedLanguagePairList.firstWhereOrNull(
            (e) {
              return e.sourceLanguage == translationTarget?.sourceLanguage &&
                  e.targetLanguage == translationTarget?.targetLanguage;
            },
          );
          if (languagePair == null) {
            unsupportedEngineIdList.add(identifier);
          } else {
            engineIdList.add(identifier);
          }
        } catch (error) {
          engineIdList.add(identifier);
        }
      }

      _translationResultList[i].unsupportedEngineIdList =
          unsupportedEngineIdList;

      for (int j = 0; j < engineIdList.length; j++) {
        String identifier = engineIdList[j];

        TranslationResultRecord translationResultRecord =
            TranslationResultRecord(
          id: shortid.generate(),
          translationEngineId: identifier,
          translationTargetId: translationTarget?.id,
        );
        _translationResultList[i]
            .translationResultRecordList!
            .add(translationResultRecord);

        Future<bool> future = Future<bool>.sync(() async {
          LookUpRequest? lookUpRequest;
          LookUpResponse? lookUpResponse;
          UniTranslateClientError? lookUpError;
          if ((translateClient.use(identifier).supportedScopes)
              .contains(TranslationEngineScope.lookUp)) {
            try {
              lookUpRequest = LookUpRequest(
                sourceLanguage: translationTarget!.sourceLanguage!,
                targetLanguage: translationTarget.targetLanguage!,
                word: _text,
              );
              lookUpResponse = await translateClient //
                  .use(identifier)
                  .lookUp(lookUpRequest);
            } on UniTranslateClientError catch (error) {
              lookUpError = error;
            } catch (error) {
              lookUpError = UniTranslateClientError(message: error.toString());
            }
          }

          TranslateRequest? translateRequest;
          TranslateResponse? translateResponse;
          UniTranslateClientError? translateError;

          if ((translateClient.use(identifier).supportedScopes)
              .contains(TranslationEngineScope.translate)) {
            try {
              translateRequest = TranslateRequest(
                sourceLanguage: translationTarget!.sourceLanguage,
                targetLanguage: translationTarget.targetLanguage,
                text: _text,
              );
              translateResponse = await translateClient //
                  .use(identifier)
                  .translate(translateRequest);
              if (translateResponse is StreamTranslateResponse) {
                translateResponse.stream.listen(
                  (event) {
                    setState(() {});
                  },
                  onDone: () {},
                );
              }
            } on UniTranslateClientError catch (error) {
              translateError = error;
            } catch (error) {
              translateError =
                  UniTranslateClientError(message: error.toString());
            }
          }

          if (lookUpResponse != null) {
            _translationResultList[i]
                .translationResultRecordList![j]
                .lookUpRequest = lookUpRequest;
            _translationResultList[i]
                .translationResultRecordList![j]
                .lookUpResponse = lookUpResponse;
          }
          if (lookUpError != null) {
            _translationResultList[i]
                .translationResultRecordList![j]
                .lookUpError = lookUpError;
          }

          if (translateResponse != null) {
            _translationResultList[i]
                .translationResultRecordList![j]
                .translateRequest = translateRequest;
            _translationResultList[i]
                .translationResultRecordList![j]
                .translateResponse = translateResponse;
          }
          if (translateError != null) {
            _translationResultList[i]
                .translationResultRecordList![j]
                .translateError = translateError;
          }

          setState(() {});

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
      if (_configuration.inputSetting == kInputSettingSubmitWithEnter) {
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
      try {
        _isTextDetecting = true;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 10));
        RecognizeTextResponse recognizeTextResponse = await sharedOcrClient
            .use(_configuration.defaultOcrEngineId ?? '')
            .recognizeText(
              RecognizeTextRequest(
                imagePath: _capturedData?.imagePath,
              ),
            );
        _isTextDetecting = false;
        setState(() {});
        if (_configuration.autoCopyDetectedText) {
          Clipboard.setData(ClipboardData(text: recognizeTextResponse.text));
        }
        _handleTextChanged(recognizeTextResponse.text, isRequery: true);
      } catch (error) {
        String errorMessage = error.toString();
        if (error is UniOcrClientError) {
          errorMessage = error.message;
        }
        _isTextDetecting = false;
        setState(() {});
        BotToast.showText(
          text: errorMessage,
          align: Alignment.center,
        );
      }
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
    bool isFoundNewVersion = _latestVersion != null &&
        _latestVersion!.buildNumber > sharedEnv.appBuildNumber;

    bool isNoAllowedAllAccess =
        !(_isAllowedScreenCaptureAccess && _isAllowedScreenSelectionAccess);

    return Container(
      key: _bannersViewKey,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: (isFoundNewVersion || isNoAllowedAllAccess) ? 12 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFoundNewVersion)
            NewVersionFoundBanner(
              latestVersion: _latestVersion!,
            ),
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
            translationMode: _configuration.translationMode,
            onTranslationModeChanged: (newTranslationMode) {
              _configuration.translationMode = newTranslationMode;
            },
            inputSetting: _configuration.inputSetting,
            onClickExtractTextFromScreenCapture:
                _handleExtractTextFromScreenCapture,
            onClickExtractTextFromClipboard: _handleExtractTextFromClipboard,
            onButtonTappedClear: _handleButtonTappedClear,
            onButtonTappedTrans: _handleButtonTappedTrans,
          ),
          TranslationTargetSelectView(
            translationMode: _configuration.translationMode,
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
      translationMode: _configuration.translationMode,
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    handleDismissed() => setState(() {});

    return PreferredSize(
      preferredSize: const Size.fromHeight(34),
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ToolbarItemAlwaysOnTop(),
            Expanded(child: Container()),
            ToolbarItemSettings(
              onSubPageDismissed: handleDismissed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _windowResize());
    return Scaffold(
      appBar: _buildAppBar(context),
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
    if (_configuration.inputSetting != kInputSettingSubmitWithMetaEnter) {
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

      TranslateResponse translateResponse = await translateClient
          .use(_configuration.defaultTranslateEngineId!)
          .translate(
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

  void _handleTrayIconMouseDown() async {
    _windowShow(isShowBelowTray: true);
  }

  void _handleTrayIconRightMouseDown() {
    _trayIcon?.openContextMenu();
  }

  void _handleTrayMenuItemClick(String key) async {
    switch (key) {
      case kMenuItemKeyShow:
        await Future.delayed(const Duration(milliseconds: 300));
        await _windowShow();
        break;
      case kMenuItemKeyQuickStartGuide:
        nativeapi.UrlOpener.instance.open('${sharedEnv.webUrl}/docs');
        break;
      case kMenuSubItemKeyJoinDiscord:
        nativeapi.UrlOpener.instance.open('https://discord.gg/yRF62CKza8');
        break;
      case kMenuSubItemKeyJoinQQGroup:
        nativeapi.UrlOpener.instance.open(
          'https://jq.qq.com/?_wv=1027&k=vYQ5jW7y',
        );
        break;
      case kMenuItemKeyQuitApp:
        _destroyTrayIcon();
        exit(0);
    }
  }
}
