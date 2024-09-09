import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';

class CustomToggleSwitch extends ConsumerWidget {
  final int? initialIndex;
  final List<String> labels;
  final Function(int?)? onToggle;
  final bool changeOnTap;

  const CustomToggleSwitch({
    super.key,
    this.initialIndex,
    required this.labels,
    this.onToggle,
    this.changeOnTap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return CustomDecorationContainer(
      // height: 70,
      width: double.infinity,
      child: ToggleSwitch(
        minWidth: double.infinity,
        minHeight: 50,
        fontSize: theme.primaryTextTheme.bodyMedium?.fontSize ?? 16,
        multiLineText: true,
        initialLabelIndex: initialIndex,
        activeBgColor: [changeOnTap ? theme.primaryColor : theme.disabledColor],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.transparent,
        inactiveFgColor:
            theme.primaryTextTheme.bodyMedium!.color?.withAlpha(100),
        totalSwitches: labels.length,
        labels: labels,
        radiusStyle: true,
        dividerColor: theme.shadowColor,
        onToggle: onToggle,
        changeOnTap: changeOnTap,
      ),
    );
  }
}
