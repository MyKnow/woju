import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woju/service/debug_service.dart';

/// # AdaptiveActionSheet
///
/// - 현재 플랫폼에 따라 Android, iOS 형태로 사용할 수 있는 어댑티브 액션 시트
///
/// ### Methods
///
/// - [AdaptiveActionSheet.show] : 어댑티브 액션 시트 표시
///
class AdaptiveActionSheet {
  /// ### 어댑티브 액션 시트 표시
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] - [context] : 컨텍스트
  /// - [String]? - [title] : 제목
  /// - [String]? - [message] : 메시지
  /// - [Map]<[Widget], [VoidCallback]> - [actions] : 표시할 Text Widget, Function의 Dictionary
  ///
  static void show(
    BuildContext context, {
    String? title,
    String? message,
    required Map<Widget, VoidCallback> actions,
  }) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: title != null ? Text(title).tr() : null,
          message: message != null ? Text(message).tr() : null,
          actions: <Widget>[
            ...actions.keys.map((action) => CupertinoActionSheetAction(
                  onPressed: actions[action] ?? () {},
                  child: action,
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("common.cancel").tr(), // TODO: 추후 json에 추가
            onPressed: () {
              printd("Navigator pop by cancel button");
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      showBottomSheet(
        context: context,
        builder: (context) => Column(
          children: [
            title != null ? Text(title).tr() : const SizedBox.shrink(),
            message != null ? Text(message).tr() : const SizedBox.shrink(),
            // actions 리스트를 순회하면 ListTile 형태로 반환
            ...actions.keys.map(
              (action) => ListTile(
                title: action,
                onTap: actions[action],
              ),
            ),
          ],
        ),
      );
    }
  }
}
