import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/theme_state_notififer.dart';

class CustomTextButton extends ConsumerWidget {
  final String text;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Size? minimumSize;
  final Map<String, String>? namedArgs;
  final TextStyle? textStyle;

  const CustomTextButton(
    this.text, {
    super.key,
    this.padding = EdgeInsets.zero,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.minimumSize = const Size(80, 80),
    this.onPressed,
    this.namedArgs,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeStateNotifierProvider.notifier).theme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        shape: shape,
        disabledForegroundColor: theme.disabledColor,
        minimumSize: minimumSize,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle ??
            theme.primaryTextTheme.bodyMedium?.copyWith(
              color: theme.primaryColor,
            ),
      ).tr(namedArgs: namedArgs),
    );
  }
}
