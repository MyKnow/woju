import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CustomDecorationContainer extends ConsumerWidget {
  final Widget child;
  final double? width;
  final double? height;
  final String? headerText;
  final EdgeInsetsGeometry? hearderTextPadding;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const CustomDecorationContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.headerText,
    this.hearderTextPadding,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowTheme = Theme.of(context);

    return Column(
      children: [
        if (headerText != null)
          Container(
            width: double.infinity,
            padding: hearderTextPadding,
            margin: margin,
            child: CustomText(
              headerText as String,
              isBold: true,
              isColorful: true,
            ),
          ),
        SizedBox(
          width: width,
          height: 1,
        ),
        Container(
          width: width,
          height: height,
          padding: padding,
          margin: (headerText == null) ? margin : const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: nowTheme.cardTheme.color ?? nowTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: nowTheme.cardTheme.shadowColor ?? nowTheme.shadowColor,
                blurRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
