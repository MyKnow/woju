import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/onboarding/phone_number_state_notifier.dart';
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
  final bool isEditing;
  final bool isDisabled;
  const CustomCountryPickerWidget(
      {super.key, this.isEditing = false, this.isDisabled = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final phonenumberNotifier = ref.watch(phoneNumberStateProvider(
      isEditing,
    ).notifier);

    return CountryCodePicker(
      backgroundColor: theme.cardColor,
      onChanged: phonenumberNotifier.updateCountryCode,
      dialogBackgroundColor: theme.cardColor,
      dialogTextStyle: theme.primaryTextTheme.bodyMedium,
      dialogSize: const Size(350, 500),
      initialSelection: 'KR',
      favorite: const ['KR', 'US'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      padding: EdgeInsets.zero,
      searchDecoration: InputDecoration(
        labelText: "onboarding.signUp.searchCountry".tr(),
        labelStyle: theme.primaryTextTheme.bodyMedium,
      ),
      searchStyle: theme.primaryTextTheme.bodyMedium,
      enabled: !isDisabled,
      builder: (country) {
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
      closeIcon: const Icon(CupertinoIcons.clear),
    );
  }
}
