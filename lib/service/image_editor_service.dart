import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:woju/service/debug_service.dart';

class ImageEditorService {
  static Future<Uint8List?> openImageEditor(
      Uint8List image, BuildContext context) async {
    printd("openImageEditor 호출");
    Uint8List? result;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.memory(
          image,
          // 이미지 편집 완료 시 호출되는 콜백 함수
          onImageEditingComplete: (Uint8List byte) async {
            result = byte;
            printd("Navigator pop by onImageEditingComplete");
            Navigator.pop(context);
          },
          // 편집되지 않은 이미지도 저장
          allowCompleteWithEmptyEditing: true,
          // 설정 변경
          configs: ProImageEditorConfigs(
            // 플랫폼에 따라 디자인 모드 변경
            designMode: (Platform.isAndroid)
                ? ImageEditorDesignModeE.material
                : ImageEditorDesignModeE.cupertino,
            cropRotateEditorConfigs: const CropRotateEditorConfigs(
              // 이미지 비율을 정사각형만 허용함
              initAspectRatio: 1,
              canChangeAspectRatio: false,
            ),
            i18n: I18n(
              paintEditor: I18nPaintingEditor(
                bottomNavigationBarText:
                    'imageEditor.paintEditor.bottomNavigationBarText'.tr(),
                freestyle: 'imageEditor.paintEditor.freestyle'.tr(),
                arrow: 'imageEditor.paintEditor.arrow'.tr(),
                line: 'imageEditor.paintEditor.line'.tr(),
                rectangle: 'imageEditor.paintEditor.rectangle'.tr(),
                circle: 'imageEditor.paintEditor.circle'.tr(),
                dashLine: 'imageEditor.paintEditor.dashLine'.tr(),
                lineWidth: 'imageEditor.paintEditor.lineWidth'.tr(),
                toggleFill: 'imageEditor.paintEditor.toggleFill'.tr(),
                undo: 'imageEditor.undo'.tr(),
                redo: 'imageEditor.redo'.tr(),
                done: 'imageEditor.paintEditor.done'.tr(),
                back: 'imageEditor.paintEditor.back'.tr(),
                smallScreenMoreTooltip:
                    'imageEditor.paintEditor.smallScreenMoreTooltip'.tr(),
              ),
              textEditor: I18nTextEditor(
                inputHintText: 'imageEditor.textEditor.inputHintText'.tr(),
                bottomNavigationBarText:
                    'imageEditor.textEditor.bottomNavigationBarText'.tr(),
                back: 'imageEditor.textEditor.back'.tr(),
                done: 'imageEditor.textEditor.done'.tr(),
                textAlign: 'imageEditor.textEditor.textAlign'.tr(),
                fontScale: 'imageEditor.textEditor.fontScale'.tr(),
                backgroundMode: 'imageEditor.textEditor.backgroundMode'.tr(),
                smallScreenMoreTooltip:
                    'imageEditor.textEditor.smallScreenMoreTooltip'.tr(),
              ),
              cropRotateEditor: I18nCropRotateEditor(
                bottomNavigationBarText:
                    'imageEditor.cropRotateEditor.bottomNavigationBarText'.tr(),
                rotate: 'imageEditor.cropRotateEditor.rotate'.tr(),
                ratio: 'imageEditor.cropRotateEditor.ratio'.tr(),
                back: 'imageEditor.cropRotateEditor.back'.tr(),
                done: 'imageEditor.cropRotateEditor.done'.tr(),
                cancel: 'imageEditor.cropRotateEditor.cancel'.tr(),
                prepareImageDialogMsg:
                    'imageEditor.cropRotateEditor.prepareImageDialogMsg'.tr(),
                applyChangesDialogMsg:
                    'imageEditor.cropRotateEditor.applyChangesDialogMsg'.tr(),
                smallScreenMoreTooltip:
                    'imageEditor.cropRotateEditor.smallScreenMoreTooltip'.tr(),
                reset: 'imageEditor.cropRotateEditor.reset'.tr(),
              ),
              filterEditor: I18nFilterEditor(
                applyFilterDialogMsg:
                    'imageEditor.filterEditor.applyFilterDialogMsg'.tr(),
                bottomNavigationBarText:
                    'imageEditor.filterEditor.bottomNavigationBarText'.tr(),
                back: 'imageEditor.filterEditor.back'.tr(),
                done: 'imageEditor.filterEditor.done'.tr(),
                filters: I18nFilters(
                  none: 'imageEditor.filterEditor.filters.none'.tr(),
                ),
              ),
              blurEditor: I18nBlurEditor(
                applyBlurDialogMsg:
                    'imageEditor.blurEditor.applyBlurDialogMsg'.tr(),
                bottomNavigationBarText:
                    'imageEditor.blurEditor.bottomNavigationBarText'.tr(),
                done: 'imageEditor.blurEditor.done'.tr(),
                back: 'imageEditor.blurEditor.back'.tr(),
              ),
              emojiEditor: I18nEmojiEditor(
                bottomNavigationBarText:
                    'imageEditor.emojiEditor.bottomNavigationBarText'.tr(),
                search: 'imageEditor.emojiEditor.search'.tr(),
                noRecents: 'imageEditor.emojiEditor.noRecents'.tr(),
              ),
              done: "imageEditor.done".tr(),
              cancel: "imageEditor.cancel".tr(),
              redo: "imageEditor.redo".tr(),
              undo: "imageEditor.undo".tr(),
              remove: "imageEditor.remove".tr(),
              doneLoadingMsg: "imageEditor.doneLoadingMsg".tr(),
            ),
          ),
        ),
      ),
    );

    return result;
  }
}
