import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woju/theme/widget/custom_text.dart';

class ToastMessageService {
  static void show(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.NONE,
    );
  }

  /// ### Flutter 내장 SnackBar
  ///
  /// #### Notes
  ///
  /// flutter 내장 SnackBar를 사용하여 메시지를 표시합니다.
  ///
  /// #### Parameters
  ///
  /// - [String] message: 표시할 메시지
  /// - [BuildContext] context: BuildContext
  /// - [Map<String, String>] namedArgs: 메시지에 포함될 변수
  /// - [bool] isLocalize: 메시지를 로컬라이즈 할지 여부 (이미 로컬라이즈된 메시지일 경우 false)
  ///
  static void nativeSnackbar(
    String message,
    BuildContext context, {
    Map<String, String>? namedArgs,
    bool isLocalize = true,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          message,
          namedArgs: namedArgs,
          isLocalize: isLocalize,
        ),
      ),
    );
  }
}
