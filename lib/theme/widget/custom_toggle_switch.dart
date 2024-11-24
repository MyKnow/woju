import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CustomToggleSwitch extends ConsumerWidget {
  final String? headerText;
  final VoidCallback? headerIconOnPressed;
  final String? headerIconTooltip;
  final int currentValue;
  final List<int> values;
  final List<IconData>? iconOfValue;
  final List<String> labelOfValue;
  final bool? bottomLabelEnable;
  final void Function(int) onToggle;
  final bool? isEnable;

  const CustomToggleSwitch({
    super.key,
    this.headerText,
    this.headerIconOnPressed,
    this.headerIconTooltip,
    required this.currentValue,
    required this.values,
    this.iconOfValue,
    required this.labelOfValue,
    required this.onToggle,
    this.bottomLabelEnable,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // 사용감 슬라이더 헤더 (설명 및 설명 페이지 이동 버튼)
        if (headerText != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                headerText as String,
                isBold: true,
                isColorful: true,
              ),

              // 설명 페이지 이동 버튼
              if (headerIconOnPressed != null)
                IconButton(
                  icon: Icon(
                    CupertinoIcons.info_circle_fill,
                    color: theme.disabledColor,
                  ),
                  onPressed: headerIconOnPressed,
                  tooltip: (headerIconTooltip ?? headerText as String).tr(),
                  iconSize: 24,
                  splashRadius: 24,
                ),
            ],
          ),

        // 사용감 슬라이더
        Container(
          width: double.infinity,
          height: 56,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: theme.cardTheme.shadowColor ?? theme.shadowColor,
                blurRadius: 2,
              ),
            ],
          ),
          child: AnimatedToggleSwitch<int>.size(
            current: currentValue,
            borderWidth: 1,
            style: ToggleStyle(
              backgroundColor: theme.cardTheme.color,
              borderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            values: values,
            selectedIconScale: 1.0,
            indicatorSize: const Size.fromWidth(double.infinity),
            iconAnimationType: AnimationType.onHover,
            styleAnimationType: AnimationType.onHover,
            spacing: 1.0,
            customIconBuilder: (context, local, global) {
              if (iconOfValue != null) {
                return Icon(
                  (iconOfValue as List<IconData>)[local.index],
                  // 현재 index가 선택된 항목이라면 흰색으로 출력
                  color: local.index == currentValue
                      ? Colors.white
                      : theme.disabledColor,
                );
              }

              return CustomText(
                labelOfValue[local.index],
                // 현재 index가 선택된 항목이라면 흰색으로 출력
                style: theme.primaryTextTheme.bodyMedium?.copyWith(
                  color: local.index == currentValue
                      ? Colors.white
                      : theme.disabledColor,
                ),
              );
            },
            onChanged: (isEnable == true) ? onToggle : null,
          ),
        ),

        // 라벨
        if (bottomLabelEnable == true)
          Container(
            width: double.infinity,
            height: 24,
            margin: const EdgeInsets.only(top: 8.0),
            alignment: Alignment.center,
            child: CustomText(
              labelOfValue[currentValue],
              style: theme.primaryTextTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ),
      ],
    );
  }
}
