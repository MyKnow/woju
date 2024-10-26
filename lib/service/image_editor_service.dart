import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/modules/crop_rotate_editor/crop_rotate_editor.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import 'package:woju/service/debug_service.dart';

class ImageEditorService {
  /// ### openImageEditor
  ///
  /// - 이미지 편집 기능을 모두 갖춘 ImageEditorPage를 Push하는 함수
  ///
  /// #### Parameters
  /// - [Uint8List] - [image] : 편집 할 이미지 원본
  /// - [BuildContext] - [context] : 현재 context
  ///
  /// #### Returns
  /// - [Future]<[Uint8List]?> : 편집된 이미지
  ///
  static Future<Uint8List?> openImageEditor(
    Uint8List image,
    BuildContext context,
  ) async {
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
            i18n: _getLocalizedI18n(),
          ),
        ),
      ),
    );

    return result;
  }

  /// ### openCropEditor
  ///
  /// - 특정 비율로만 이미지를 업로드 할 수 있도록, 이미지 추가 단계에서 1:1 크롭을 강제하는 메서드
  /// - Crop&Rotate를 진행 한 이후, 바로 openImageEditor를 실행하여 그 결과값을 반환함
  ///
  /// #### Parameters
  /// - [Uint8List] - [image] : 편집 할 이미지 원본
  /// - [BuildContext] - [context] : 현재 context
  ///
  /// #### Returns
  /// - [Future]<[Uint8List]?> : 크롭되고 편집된 이미지
  ///
  static Future<Uint8List?> openCropEditor(
    Uint8List image,
    BuildContext context,
  ) async {
    printd("openCropEditor 호출");
    final cropReuslt = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final cropResult = CropRotateEditor.memory(
            image,
            theme: ThemeData.dark(),
            imageSize: const Size(500, 500),
            configs: ProImageEditorConfigs(
              i18n: _getLocalizedI18n(),
              cropRotateEditorConfigs: const CropRotateEditorConfigs(
                initAspectRatio: 1,
                canChangeAspectRatio: false,
              ),
            ),
          );
          return cropResult;
        },
      ),
    );

    Uint8List? result = (cropReuslt as CropRotateEditorRes).result.bytes;
    printd("cropResult : $result");

    if (context.mounted && result != null) {
      result = await openImageEditor(result, context);
    }

    return result;
  }

  /// ### _getLocalizedI18n
  ///
  /// - 인터페이스의 글자들을 모두 localization한 설정을 반환한다.
  ///
  /// #### Returns
  /// - [I18n] : 로컬라이즈된 I18n
  ///
  static I18n _getLocalizedI18n() {
    return I18n(
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
        applyBlurDialogMsg: 'imageEditor.blurEditor.applyBlurDialogMsg'.tr(),
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
    );
  }
}
