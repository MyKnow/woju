import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:woju/model/sign_up_model.dart';
import 'package:woju/service/debug_service.dart';

final signUpStateProvider =
    StateNotifierProvider<SignUpStateNotifier, SignUpModel>(
  (ref) => SignUpStateNotifier(),
);

class SignUpStateNotifier extends StateNotifier<SignUpModel> {
  SignUpStateNotifier() : super(SignUpModel.initial());

  void update(PhoneNumber phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateAuthCode(String authCode) {
    state = state.copyWith(authCode: authCode);
  }

  void updateAuthCodeSent(bool authCodeSent) {
    state = state.copyWith(authCodeSent: authCodeSent);
  }
}

/// ### 회원가입 페이지의 Action을 확장하는 Extension
///
extension SignUpAction on SignUpStateNotifier {
  void sendAuthCode() {
    printd("sendAuthCode");
    updateAuthCodeSent(true);
  }
}
