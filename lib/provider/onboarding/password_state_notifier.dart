import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_password_model.dart';

/// ### passwordStateProvider
///
/// #### Notes
/// - autoDispose 속성을 가지므로, 해당 Provider가 더 이상 필요 없을 때 자동으로 해제됨
/// - [PasswordStateNotifier] 유저 비밀번호 상태를 관리하는 StateNotifier
///
final passwordStateProvider =
    StateNotifierProvider.autoDispose<PasswordStateNotifier, UserPasswordModel>(
  (ref) => PasswordStateNotifier(),
);

/// ### currentPasswordStateProvider
///
/// #### Notes
/// - autoDispose 속성을 가지므로, 해당 Provider가 더 이상 필요 없을 때 자동으로 해제됨
/// - [PasswordStateNotifier] 현재 유저 비밀번호 상태를 관리하는 StateNotifier
///
final currentPasswordStateProvider =
    StateNotifierProvider.autoDispose<PasswordStateNotifier, UserPasswordModel>(
  (ref) => PasswordStateNotifier(),
);

/// ### PasswordStateNotifier
///
/// - 유저 비밀번호 상태를 관리하는 StateNotifier
///
/// #### Fields
///
/// - [UserPasswordModel] state: 유저 비밀번호 상태 모델
///
/// #### Methods
///
/// - [void] updatePassword([String] password): 유저 비밀번호 업데이트
/// - [void] updateVisiblePassword(): 유저 비밀번호 보임 여부 토글
/// - [void] reset(): 유저 비밀번호 초기화
/// - [UserPasswordModel] getPasswordModel: 유저 비밀번호 상태 모델 반환
///
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
