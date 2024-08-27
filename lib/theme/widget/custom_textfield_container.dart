import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';

class CustomTextfieldContainer extends ConsumerWidget {
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool? enabled;
  final bool? obscureText;
  final TextStyle? textStyle;
  final List<Widget> actions;
  final String? initialValue;
  final double verticalDividerHeight;
  final Function? onFieldSubmitted;
  final String fieldKey;

  const CustomTextfieldContainer({
    super.key,
    required this.fieldKey,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.labelText = "input.defaultLabel",
    this.hintText,
    this.validator,
    this.focusNode,
    this.autovalidateMode,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.autofillHints,
    this.enabled = true,
    this.obscureText = false,
    this.textStyle,
    this.initialValue,
    this.verticalDividerHeight = 60,
    this.actions = const [],
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowTheme = Theme.of(context);
    final TextFormField textFormField = TextFormField(
      key: Key(fieldKey),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        prefix: prefix,
        prefixIcon: prefixIcon,
        suffix: suffix,
        suffixIcon: suffixIcon,
        labelText: (labelText != null) ? (labelText as String) : null,
        hintText: (hintText != null) ? (hintText as String) : null,
        labelStyle: nowTheme.primaryTextTheme.titleMedium?.copyWith(
          color: nowTheme.primaryTextTheme.bodyMedium?.color,
        ),
        errorStyle: nowTheme.primaryTextTheme.labelMedium?.copyWith(
          color: Colors.red,
        ),
      ),
      validator: validator,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      enabled: enabled,
      obscureText: obscureText ?? false,
      style: textStyle ?? nowTheme.primaryTextTheme.bodyMedium,
      initialValue: initialValue,
      onFieldSubmitted: (value) {
        if (textInputAction == TextInputAction.next) {
          focusNode?.nextFocus();
        } else {
          focusNode?.unfocus();
          onFieldSubmitted?.call();
        }
      },
      // keyboardAppearance: nowTheme.brightness,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomDecorationContainer(
        child: actions.isEmpty
            ? textFormField
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 360 - actions.length * 80,
                    child: textFormField,
                  ),
                  // Container(
                  //   width: 1,
                  //   height: verticalDividerHeight,
                  //   color: theme.shadowColor,
                  // ),
                  Row(
                    children: actions,
                  ),
                ],
              ),
      ),
    );
  }
}
