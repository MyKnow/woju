import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomFloatingButton {
  static const centerDocked = FloatingActionButtonLocation.centerDocked;
  static Widget build(BuildContext context, WidgetRef ref,
      VoidCallback? onPressed, String? text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          // 키보드가 활성화 되어 있을 때만 키보드를 내리는 기능 버튼 표시
          if (MediaQuery.of(context).viewInsets.vertical > 50)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(
                  CupertinoIcons.keyboard_chevron_compact_down,
                ),
                tooltip: "accessibility.hideKeyboardButton".tr(),
              ),
            ),
          const Spacer(),
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(text).tr(),
              ),
            ),
        ],
      ),
    );
  }
}
