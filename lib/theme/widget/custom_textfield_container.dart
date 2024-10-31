import 'package:easy_localization/easy_localization.dart';
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
  final String? headerText;
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
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final List<Widget> actions;
  final String? initialValue;
  final double verticalDividerHeight;
  final Function? onFieldSubmitted;
  final String fieldKey;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? hearderTextPadding;
  final bool? labelTextEnable;
  final int? maxLines;

  const CustomTextfieldContainer({
    super.key,
    required this.fieldKey,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.headerText,
    this.validator,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
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
    this.width,
    this.actions = const [],
    this.onFieldSubmitted,
    this.controller,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.hearderTextPadding =
        const EdgeInsets.only(left: 32, bottom: 15, top: 16),
    this.labelTextEnable = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultLabel = "input.defaultLabel".tr();
    final nowTheme = Theme.of(context);
    final TextFormField textFormField = TextFormField(
      maxLines: maxLines,
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
        labelText: (labelText != null)
            ? (labelText as String)
            : (labelTextEnable == true)
                ? defaultLabel
                : null,
        hintText: (hintText != null) ? (hintText as String) : null,
        hintStyle: nowTheme.primaryTextTheme.bodyMedium?.copyWith(
          color: nowTheme.disabledColor.withOpacity(0.7),
        ),
        labelStyle: (enabled ?? false)
            ? nowTheme.primaryTextTheme.titleMedium?.copyWith(
                color: nowTheme.primaryTextTheme.bodyMedium?.color,
              )
            : nowTheme.textTheme.titleMedium
                ?.copyWith(color: nowTheme.disabledColor.withOpacity(0.7)),
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
      style: textStyle ??
          ((enabled ?? false)
              ? nowTheme.primaryTextTheme.bodyMedium
              : nowTheme.primaryTextTheme.bodyMedium?.copyWith(
                  color: nowTheme.disabledColor.withOpacity(
                    0.7,
                  ),
                )),
      initialValue: initialValue,
      onFieldSubmitted: (value) {
        if (textInputAction == TextInputAction.next) {
          focusNode?.nextFocus();
        } else {
          focusNode?.unfocus();
          onFieldSubmitted?.call();
        }
      },
      controller: controller,
      // keyboardAppearance: nowTheme.brightness,
    );
    // actions의 IconButton의 width를 계산하여 actionsWidth를 구함
    final actionsWidth = actions.fold<double>(
      0,
      (previousValue, element) {
        return previousValue + ((element.runtimeType == IconButton) ? 41 : 80);
      },
    );

    return CustomDecorationContainer(
      margin: margin,
      width: double.infinity,
      headerText: headerText,
      hearderTextPadding: hearderTextPadding,
      child: actions.isEmpty
          ? textFormField
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 360 - actionsWidth,
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
    );
  }
}
