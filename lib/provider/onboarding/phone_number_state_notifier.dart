import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_phone_model.dart';

final phoneNumberStateProvider = StateNotifierProvider.autoDispose<
    PhoneNumberStateNotififer, UserPhoneModel>(
  (ref) => PhoneNumberStateNotififer(ref),
);

class PhoneNumberStateNotififer extends StateNotifier<UserPhoneModel> {
  late final Ref ref;
  PhoneNumberStateNotififer(this.ref) : super(UserPhoneModel.initial());

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateCountryCode(CountryCode countryCode) {
    state = state.copyWith(
        dialCode: countryCode.dialCode, isoCode: countryCode.code);
  }

  void reset() {
    state = UserPhoneModel.initial();
  }

  UserPhoneModel get getPhoneNumberModel => super.state;
}

extension PhoneNumberAction on PhoneNumberStateNotififer {}
