import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_password_model.dart';

final passwordStateProvider =
    StateNotifierProvider.autoDispose<PasswordStateNotifier, UserPasswordModel>(
  (ref) => PasswordStateNotifier(),
);

final currentPasswordStateProvider =
    StateNotifierProvider.autoDispose<PasswordStateNotifier, UserPasswordModel>(
  (ref) => PasswordStateNotifier(),
);

class PasswordStateNotifier extends StateNotifier<UserPasswordModel> {
  PasswordStateNotifier() : super(UserPasswordModel.initial());

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateVisiblePassword() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void reset() {
    state = UserPasswordModel.initial();
  }

  UserPasswordModel get getPasswordModel => super.state;
}
