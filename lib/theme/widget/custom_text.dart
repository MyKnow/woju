import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer_const_constructors
/// # [CustomText]
/// - CustomText widget
///
/// ### Fields
/// - [String] - [text] : 내용
/// - [TextStyle] - [style] : 스타일
///
class CustomText extends ConsumerWidget {
  /// [String] - [text] : 내용
  final String text;

  /// [TextStyle] - [style] : 스타일
  final TextStyle? style;
  final TextAlign? textAlign;
  final Map<String, String>? namedArgs;
  final bool isColorful;
  final bool isLocalize;
  final bool isBold;
  final bool isTitle;
  final bool isWhite;
  final bool isDisabled;
  final int? maxLines;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.namedArgs,
    this.isColorful = false,
    this.isLocalize = true,
    this.isBold = false,
    this.isTitle = false,
    this.isWhite = false,
    this.isDisabled = false,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle? textStyle;
    final theme = Theme.of(context);

    if (style != null) {
      textStyle = style;
    } else {
      if (isTitle) {
        textStyle = theme.primaryTextTheme.titleLarge;
      } else {
        if (isBold) {
          textStyle = theme.primaryTextTheme.bodyLarge;
        } else {
          textStyle = theme.primaryTextTheme.bodyMedium;
        }
      }
    }

    return Text(
      isLocalize ? text.tr(namedArgs: namedArgs) : text,
      style: style ??
          textStyle?.copyWith(
            color: isDisabled
                ? theme.disabledColor
                : isColorful
                    ? theme.primaryColor
                    : (isWhite)
                        ? Colors.white
                        : theme.primaryTextTheme.bodyMedium?.color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
      textAlign: textAlign,
      overflow: (maxLines == null) ? null : TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
