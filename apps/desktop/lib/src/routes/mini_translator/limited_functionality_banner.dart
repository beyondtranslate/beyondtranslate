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

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (_isAllowedAllAccess) return Container();

    return Container(
      color: Colors.orange,
      width: double.infinity,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
        ),
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 18,
          right: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: t.mini_translator.limited_banner.title,
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
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
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                if (kIsMacOS) ...[
                  Text.rich(
                    TextSpan(
                      text: t.mini_translator.limited_banner.button.go_settings,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.3,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = MacSettings.showAndHighlightPermissions,
                    ),
                    style: textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 18),
                ],
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            t.mini_translator.limited_banner.button.check_again,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.3,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onTappedRecheckIsAllowedAllAccess,
                      ),
                    ],
                  ),
                  style: textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
