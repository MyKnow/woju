import 'dart:io';
import 'dart:typed_data';
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
            i18n: const I18n(),
          ),
        ),
      ),
    );

    return result;
  }
}
