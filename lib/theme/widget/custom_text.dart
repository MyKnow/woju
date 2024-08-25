import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/theme_state_notififer.dart';

// ignore: prefer_const_constructors
class CustomText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Map<String, String>? namedArgs;
  final bool isColorful;
  final bool isLocalize;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.namedArgs,
    this.isColorful = false,
    this.isLocalize = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeStateNotifierProvider.notifier).theme;
    return Text(
      isLocalize ? text.tr(namedArgs: namedArgs) : text,
      style: style ??
          theme.primaryTextTheme.bodyMedium?.copyWith(
            color: isColorful
                ? theme.primaryColor
                : theme.primaryTextTheme.bodyMedium?.color,
          ),
      textAlign: textAlign,
    );
  }
}
