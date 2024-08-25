import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_phone_model.dart';

final phoneNumberStateProvider =
    StateNotifierProvider<PhoneNumberStateNotififer, UserPhoneModel>(
  (ref) => PhoneNumberStateNotififer(ref),
);

class PhoneNumberStateNotififer extends StateNotifier<UserPhoneModel> {
  late final Ref ref;
  PhoneNumberStateNotififer(this.ref) : super(UserPhoneModel.initial());

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateDialCode(String dialCode) {
    state = state.copyWith(dialCode: dialCode);
  }

  void updateIsoCode(String isoCode) {
    state = state.copyWith(isoCode: isoCode);
  }

  void reset() {
    state = UserPhoneModel.initial();
  }

  UserPhoneModel get getPhoneNumberModel => super.state;
}

extension PhoneNumberAction on PhoneNumberStateNotififer {}
