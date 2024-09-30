import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Size? minimumSize;
  final Map<String, String>? namedArgs;
  final TextStyle? textStyle;
  final AlignmentGeometry alignment;

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
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowTheme = Theme.of(context);

    // onPressed가 null이면 비활성화된 스타일을 적용
    return Container(
      width: minimumSize?.width,
      alignment: alignment,
      child: TextButton(
        onPressed: (onPressed != null) ? onPressed : null,
        style: TextButton.styleFrom(
          padding: padding,
          shape: shape,
          minimumSize: minimumSize,
          disabledForegroundColor: nowTheme.disabledColor,
          alignment: alignment,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ??
              nowTheme.primaryTextTheme.bodyLarge?.copyWith(
                color: onPressed == null
                    ? nowTheme.disabledColor
                    : nowTheme.primaryColor,
              ),
          // overflow: TextOverflow.ellipsis,
        ).tr(namedArgs: namedArgs),
      ),
    );
  }
}
