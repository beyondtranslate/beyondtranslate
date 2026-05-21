import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/mac_settings.dart';
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/button.dart';

class LimitedFunctionalityBanner extends StatelessWidget {
  const LimitedFunctionalityBanner({
    Key? key,
    required this.isAllowedScreenCaptureAccess,
    required this.isAllowedScreenSelectionAccess,
    required this.onTappedRecheckIsAllowedAllAccess,
  }) : super(key: key);
  final bool isAllowedScreenCaptureAccess;
  final bool isAllowedScreenSelectionAccess;
  final VoidCallback onTappedRecheckIsAllowedAllAccess;

  bool get _isAllowedAllAccess =>
      isAllowedScreenCaptureAccess && isAllowedScreenSelectionAccess;

  String _titleText() {
    final permission = t.mini_translator.limited_banner.permission;
    if (!isAllowedScreenCaptureAccess && !isAllowedScreenSelectionAccess) {
      return permission.missing_both;
    }
    if (!isAllowedScreenCaptureAccess) {
      return permission.missing_screen_capture;
    }
    return permission.missing_accessibility;
  }

  @override
  Widget build(BuildContext context) {
    if (_isAllowedAllAccess) return const SizedBox.shrink();

    const baseStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.5,
      fontWeight: FontWeight.w400,
      height: 1.45,
    );
    const linkStyle = TextStyle(
      color: Colors.white,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white,
      fontWeight: FontWeight.w500,
    );
    final limitedBanner = t.mini_translator.limited_banner;
    final instruction = limitedBanner.instruction;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5892A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Tooltip(
                  message: t.mini_translator.limited_banner.tooltip.help,
                  child: Button(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final url = '${sharedEnv.webUrl}/docs';
                      final result = nativeapi.UrlOpener.instance.open(url);
                      if (!result.success) {
                        throw 'Could not launch $url: ${result.errorMessage}';
                      }
                    },
                    child: const Icon(
                      FluentIcons.question_circle_20_regular,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: _titleText()),
                      if (kIsMacOS) ...[
                        const TextSpan(text: ' '),
                        TextSpan(text: instruction.app_settings_prefix),
                        TextSpan(
                          text: limitedBanner.action.app_settings,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = MacSettings.showAndHighlightPermissions,
                        ),
                        TextSpan(text: instruction.follow_guide_prefix),
                        TextSpan(
                          text: limitedBanner.action.recheck,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = onTappedRecheckIsAllowedAllAccess,
                        ),
                        TextSpan(text: instruction.suffix),
                      ],
                    ],
                  ),
                  style: baseStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
