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
  final bool? decorationEnable;

  const CustomDecorationContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.headerText,
    this.hearderTextPadding,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.decorationEnable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowTheme = Theme.of(context);

    return Container(
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (headerText != null)
            Container(
              width: double.infinity,
              padding: hearderTextPadding,
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
            margin: (headerText == null) ? null : const EdgeInsets.only(top: 8),
            decoration: decorationEnable == true
                ? BoxDecoration(
                    color: nowTheme.cardTheme.color ?? nowTheme.cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: nowTheme.cardTheme.shadowColor ??
                            nowTheme.shadowColor,
                        blurRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: child,
          ),
        ],
      ),
    );
  }
}
