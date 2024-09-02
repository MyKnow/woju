import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text_button.dart';

class CustomAppBarTextButton extends ConsumerWidget {
  final EdgeInsetsGeometry padding;
  final String? text;
  final void Function()? onPressed;
  final bool isDisabled;
  final List<Widget>? children;

  const CustomAppBarTextButton({
    super.key,
    this.padding = const EdgeInsets.only(right: 24),
    this.text,
    this.onPressed,
    this.isDisabled = true,
    this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (children != null && children!.isNotEmpty)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...children!.map(
                (widget) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget,
                ),
              ),
              Padding(
                padding: padding.subtract(
                  const EdgeInsets.only(right: 8),
                ),
              ),
            ],
          )
        : (text != null)
            ? Padding(
                padding: padding,
                child: CustomTextButton(
                  text!,
                  onPressed: onPressed,
                  minimumSize: const Size(48, 48),
                ),
              )
            : Container();
  }
}
