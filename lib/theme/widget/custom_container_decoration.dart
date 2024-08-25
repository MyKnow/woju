import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDecorationContainer extends ConsumerWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const CustomDecorationContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowTheme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: nowTheme.cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: nowTheme.cardTheme.shadowColor ?? nowTheme.shadowColor,
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}
