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
    TextTheme textTheme = Theme.of(context).textTheme;

    if (_isAllowedAllAccess) return Container();

    final baseStyle = textTheme.bodyMedium!.copyWith(
      color: Colors.white,
      fontSize: 13,
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
      color: Colors.orange,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SizedBox(
                  width: 16,
                  height: 16,
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
              ),
            ),
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
    );
  }
}
