import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CustomDatePicker extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final bool isEditing;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.isEditing = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // isEditing이 false일 경우 수정 불가능
    if (!isEditing) {
      return CustomDecorationContainer(
        height: 50,
        child: Center(
          child: CustomText(
            DateFormat.yMMMMd(context.locale.toString()).format(selectedDate),
            isDisabled: !isEditing,
          ),
        ),
      );
    }
    return CustomDecorationContainer(
      height: 150,
      child: ScrollDatePicker(
        // 만 14세 이상만 선택 가능
        maximumDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
        selectedDate: selectedDate,
        locale: context.locale,
        scrollViewOptions: DatePickerScrollViewOptions(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          year: ScrollViewDetailOptions(
            textStyle: theme.primaryTextTheme.bodyMedium!,
            selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
            alignment: Alignment.center,
          ),
          month: ScrollViewDetailOptions(
            textStyle: theme.primaryTextTheme.bodyMedium!,
            selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
            alignment: Alignment.center,
          ),
          day: ScrollViewDetailOptions(
            textStyle: theme.primaryTextTheme.bodyMedium!,
            selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
            alignment: Alignment.center,
          ),
        ),
        onDateTimeChanged: onDateChanged,
        options: DatePickerOptions(
          backgroundColor: theme.cardTheme.color!,
          diameterRatio: 1.7,
          itemExtent: 48,
          isLoop: false,
        ),
        indicator: Container(
          height: 48,
          decoration: BoxDecoration(
            color: theme.shadowColor.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
