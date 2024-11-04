import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ### ImageZoomDialog
///
/// - 이미지를 확대하여 보여주는 다이얼로그
///
/// #### Methods
/// - [static void] - [show] : 이미지를 확대하여 보여주는 다이얼로그를 띄웁니다.
///
class ImageZoomDialog {
  /// ### show
  ///
  /// - 이미지를 확대하여 보여주는 다이얼로그를 띄웁니다.
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 context
  /// - [Uint8List] - [image] : 이미지
  ///
  static void show(BuildContext context, Uint8List image) {
    // 이미지 뷰어 다이얼로그
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.memory(image),
        ),
      ),
    );
  }
}
