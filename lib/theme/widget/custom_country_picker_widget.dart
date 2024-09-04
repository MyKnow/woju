import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/theme/widget/custom_text.dart';

/// ### CustomCountryPickerWidget
///
/// #### Notes
///
/// - 나라 코드를 선택할 수 있는 위젯
/// - `CountryCodePicker` 위젯을 사용
/// - `CountryCodePicker` 위젯을 사용하여 나라 코드를 선택하고, 선택한 나라 코드를 `PhoneNumberStateNotififer`를 통해 업데이트
/// - 변경사항은 'phoneNumberStateProvider'를 통해서 구독 가능
///
class CustomCountryPickerWidget extends ConsumerWidget {
  final void Function(CountryCode)? onChanged;
  final Size dialogSize;
  final bool isDisabled;
  final bool hideSearch;
  final bool showOnlyCountry;
  final InputDecoration? searchDecoration;
  final dynamic Function(CountryCode?)? builder;
  final List<String>? countryFilter;

  const CustomCountryPickerWidget({
    super.key,
    this.isDisabled = false,
    this.onChanged,
    this.showOnlyCountry = false,
    this.dialogSize = const Size(350, 400),
    this.searchDecoration,
    this.builder,
    this.countryFilter,
    this.hideSearch = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CountryCodePicker(
      backgroundColor: theme.cardColor,
      onChanged: onChanged,
      dialogBackgroundColor: theme.cardColor,
      dialogTextStyle: theme.primaryTextTheme.bodyMedium,
      dialogSize: dialogSize,
      initialSelection: context.locale.countryCode,
      favorite: (countryFilter != null) ? [] : const ['KR', 'US'],
      showCountryOnly: showOnlyCountry,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      padding: EdgeInsets.zero,
      countryFilter: countryFilter,
      searchDecoration: searchDecoration ??
          InputDecoration(
            labelText: "onboarding.signUp.searchCountry".tr(),
            labelStyle: theme.primaryTextTheme.bodyMedium,
          ),
      searchStyle: theme.primaryTextTheme.bodyMedium,
      enabled: !isDisabled,
      hideSearch: hideSearch,
      builder: builder ??
          (country) {
            if (country == null) {
              return const SizedBox.shrink();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  country.flagUri ?? '',
                  package: 'country_code_picker',
                  width: 32,
                ),
                const SizedBox(width: 8),
                CustomText(
                  country.dialCode ?? '',
                  isDisabled: isDisabled,
                ),
              ],
            );
          },
      boxDecoration: BoxDecoration(
        color: theme.cardTheme.color,
      ),
      closeIcon: Icon(
        CupertinoIcons.clear,
        size: theme.textTheme.displayLarge?.fontSize,
        color: theme.primaryColor,
      ),
    );
  }
}
