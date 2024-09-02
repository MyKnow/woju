import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/custom_theme_data.dart';
import 'package:woju/theme/widget/custom_text.dart';

class BottomFloatingButton {
  static const location = FloatingActionButtonLocation.centerDocked;
  static Widget build(BuildContext context, WidgetRef ref,
      VoidCallback? onPressed, String? text,
      {Widget? child}) {
    final viewInsets = MediaQuery.of(context).viewInsets.vertical;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: (viewInsets > 50)
          ? BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            )
          : null,
      width: double.infinity,
      height: 55,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      transform: Matrix4.translationValues(0, -bottomPadding + 16, 0),
      child: Row(
        children: <Widget>[
          // 키보드가 활성화 되어 있을 때만 키보드를 내리는 기능 버튼 표시
          if (viewInsets > 50)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(
                  CupertinoIcons.keyboard_chevron_compact_down,
                  color: Colors.black,
                ),
                tooltip: "accessibility.hideKeyboardButton".tr(),
              ),
            ),
          const Spacer(),
          (child != null)
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: child,
                )
              : (text != null)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: CustomThemeData
                            .currentTheme.elevatedButtonTheme.style
                            ?.copyWith(
                                minimumSize:
                                    WidgetStateProperty.all(const Size(80, 40)),
                                backgroundColor: (onPressed != null)
                                    ? WidgetStateProperty.all(
                                        Theme.of(context).primaryColor)
                                    : WidgetStateProperty.all(
                                        Theme.of(context).disabledColor)),
                        child: CustomText(
                          text,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }
}
