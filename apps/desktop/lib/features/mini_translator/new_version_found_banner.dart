import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../models/version.dart';
import '../../utils/utils.dart';

class NewVersionFoundBanner extends StatelessWidget {
  const NewVersionFoundBanner({
    Key? key,
    required this.latestVersion,
  }) : super(key: key);

  final Version latestVersion;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).primaryColor,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text:
                    'page_desktop_popup.newversion_banner_text_found_new_version'
                        .tr(args: [latestVersion.version]),
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'page_desktop_popup.newversion_banner_btn_update'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.3,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url =
                            '${sharedEnv.webUrl}/release-notes#${latestVersion.version}';
                        final result = nativeapi.UrlOpener.instance.open(url);
                        if (!result.success) {
                          throw 'Could not launch $url: ${result.errorMessage}';
                        }
                      },
                  ),
                ],
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
