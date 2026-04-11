import 'dart:ui';

import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:screen_capturer/screen_capturer.dart';

class TranslationInputView extends StatelessWidget {
  const TranslationInputView({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    this.capturedData,
    required this.isTextDetecting,
    required this.translationMode,
    required this.onTranslationModeChanged,
    required this.inputSetting,
    required this.onClickExtractTextFromScreenCapture,
    required this.onClickExtractTextFromClipboard,
    required this.onButtonTappedClear,
    required this.onButtonTappedTrans,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  final CapturedData? capturedData;
  final bool isTextDetecting;

  final String translationMode;
  final ValueChanged<String> onTranslationModeChanged;
  final String inputSetting;

  final VoidCallback onClickExtractTextFromScreenCapture;
  final VoidCallback onClickExtractTextFromClipboard;

  final VoidCallback onButtonTappedClear;
  final VoidCallback onButtonTappedTrans;

  final bool isAddedToVocabulary = true;

  Widget _buildToolbarItems(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: 'page_desktop_popup.tip_translation_mode'.tr(args: [
            'translation_mode.$translationMode'.tr(),
          ]),
          child: SizedBox(
            width: 30,
            height: 26,
            child: CustomButton(
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: 30,
                height: 26,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      FluentIcons.target_20_regular,
                      size: 22,
                      color: translationMode == kTranslationModeAuto
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).iconTheme.color,
                    ),
                    if (translationMode == kTranslationModeAuto)
                      Positioned(
                        bottom: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: const EdgeInsets.only(
                            left: 2,
                            right: 2,
                            top: 1.4,
                            bottom: 1.4,
                          ),
                          child: const Text(
                            'AUTO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 5.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              onPressed: () {
                String newTranslationMode =
                    translationMode == kTranslationModeAuto
                        ? kTranslationModeManual
                        : kTranslationModeAuto;

                UserPreference? userPreference =
                    localDb.preference(kPrefTranslationMode).get();
                if (userPreference != null) {
                  localDb.preference(kPrefTranslationMode).update(
                        value: newTranslationMode,
                      );
                } else {
                  localDb.preferences.create(
                    key: kPrefTranslationMode,
                    value: newTranslationMode,
                  );
                }
                onTranslationModeChanged(newTranslationMode);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
          child: VerticalDivider(
            width: 8,
          ),
        ),
        Tooltip(
          message:
              'page_desktop_popup.tip_extract_text_from_screen_capture'.tr(),
          child: SizedBox(
            width: 30,
            height: 26,
            child: CustomButton(
              padding: EdgeInsets.zero,
              onPressed: onClickExtractTextFromScreenCapture,
              child: Icon(
                FluentIcons.crop_20_regular,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'page_desktop_popup.tip_extract_text_from_clipboard'.tr(),
          child: SizedBox(
            width: 30,
            height: 26,
            child: CustomButton(
              padding: EdgeInsets.zero,
              onPressed: onClickExtractTextFromClipboard,
              child: Icon(
                FluentIcons.clipboard_text_ltr_20_regular,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 20,
        //   child: VerticalDivider(
        //     width: 8,
        //   ),
        // ),
        // _ToolbarItemAddToNewWord(
        //   controller: controller,
        // )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 24,
          constraints: const BoxConstraints(
            minWidth: 56,
          ),
          child: CustomButton.outlined(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            borderRadius: BorderRadius.circular(2),
            onPressed: onButtonTappedClear,
            child: Text(
              'page_desktop_popup.btn_clear'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 24,
          constraints: const BoxConstraints(
            minWidth: 56,
          ),
          child: CustomButton.filled(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            borderRadius: BorderRadius.circular(2),
            onPressed: onButtonTappedTrans,
            child: Text(
              'page_desktop_popup.btn_trans'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0.0, 1.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  CupertinoTextField(
                    focusNode: focusNode,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    selectionHeightStyle: BoxHeightStyle.max,
                    controller: controller,
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 14,
                      bottom: 12,
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.2,
                    ),
                    placeholder: 'page_desktop_popup.input_hint'.tr(),
                    placeholderStyle: textTheme.bodyMedium?.copyWith(
                      color: textTheme.bodyMedium?.color?.withOpacity(0.5),
                      height: 1.2,
                    ),
                    maxLines:
                        inputSetting == kInputSettingSubmitWithEnter ? 1 : 6,
                    minLines: 1,
                    onChanged: onChanged,
                    onSubmitted: (newValue) {
                      onButtonTappedTrans();
                    },
                  ),
                  if (isTextDetecting)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        color: Theme.of(context).canvasColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SpinKitDoubleBounce(
                                  color: textTheme.bodySmall!.color,
                                  size: 18.0,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'page_desktop_popup.text_extracting_text'
                                      .tr(),
                                  style: TextStyle(
                                    color: textTheme.bodySmall!.color,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              indent: 12,
              endIndent: 12,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 6,
                right: 12,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                children: [
                  _buildToolbarItems(context),
                  Expanded(child: Container()),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
