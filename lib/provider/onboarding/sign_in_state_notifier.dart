import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/http_service.dart';

final signInStateProvider =
    StateNotifierProvider<SignInStateNotifier, SignInModel>(
  (ref) => SignInStateNotifier(ref),
);

class SignInStateNotifier extends StateNotifier<SignInModel> {
  late final Ref ref;
  SignInStateNotifier(this.ref) : super(SignInModel.initial());

  void changeLoginMethod() {
    state = state.copyWith(
      loginWithPhoneNumber: !state.loginWithPhoneNumber,
    );
  }

  void updateCountryCode(String dialCode, String isoCode) {
    state = state.copyWith(
      userPhoneModel:
          state.userPhoneModel.copyWith(dialCode: dialCode, isoCode: isoCode),
    );
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(
      userPhoneModel: state.userPhoneModel.copyWith(phoneNumber: phoneNumber),
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      userPasswordModel: state.userPasswordModel.copyWith(password: password),
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      userPasswordModel: state.userPasswordModel.togglePasswordVisibility(),
    );
  }

  void updateUserID(String userID) {
    state = state.copyWith(
      userIDModel: state.userIDModel.copyWith(userID: userID),
    );
  }

  SignInModel get getSignInModel => state;

  bool get canLogin =>
      (state.userPhoneModel.isPhoneNumberValid ||
          state.userIDModel.isIDValid) &&
      state.userPasswordModel.isPasswordAvailable;
}

extension SignInModelExtension on SignInStateNotifier {
  /// ### 로그인 방법 변경 버튼 클릭
  /// 로그인 방법을 변경합니다.
  ///
  /// #### Notes
  /// - 로그인 방법을 변경합니다.
  /// - 로그인 방법이 변경되면, [loginWithPhoneNumber] 값이 변경됩니다.
  /// - [loginWithPhoneNumber] 값이 `true`이면, 전화번호로 로그인합니다.
  /// - [loginWithPhoneNumber] 값이 `false`이면, 아이디로 로그인합니다.
  ///
  void changeLoginButton() {
    changeLoginMethod();
  }

  /// ### 국가 코드 변경
  ///
  /// #### Notes
  ///
  /// - 사용자가 국가 코드를 변경하면 호출됩니다.
  /// - 국가 코드를 변경합니다.
  /// - [dialCode]는 국가 전화번호 코드입니다.
  /// - [isoCode]는 국가 코드입니다.
  ///
  /// #### Parameters
  ///
  /// - `dialCode`: 국가 전화번호 코드
  /// - `isoCode`: 국가 코드
  ///
  void countryCodeOnChange(String? dialCode, String? isoCode) {
    if (dialCode == null || isoCode == null) return;
    updateCountryCode(dialCode, isoCode);
  }

  /// ### 전화번호 입력 OnChange 메소드
  ///
  /// #### Notes
  ///
  /// - 사용자가 전화번호를 입력하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - `phoneNumber`: 전화번호
  ///
  /// #### Returns
  ///
  /// - `void`
  ///
  void phoneNumberOnChange(String phoneNumber) {
    updatePhoneNumber(phoneNumber);
  }

  /// ### 비밀번호 입력 OnChange 메소드
  ///
  /// #### Notes
  ///
  /// - 사용자가 비밀번호를 입력하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - `password`: 비밀번호
  ///
  void passwordOnChange(String password) {
    updatePassword(password);
  }

  /// ### 비밀번호 가리기/보이기 버튼 클릭
  ///
  /// #### Notes
  ///
  /// - 사용자가 비밀번호 가리기/보이기 버튼을 클릭하면 호출됩니다.
  ///
  void togglePasswordVisibilityButton() {
    togglePasswordVisibility();
  }

  /// ### 아이디 입력 OnChange 메소드
  ///
  /// #### Notes
  ///
  /// - 사용자가 아이디를 입력하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - `userID`: 아이디
  ///
  void userIDOnChange(String userID) {
    updateUserID(userID);
  }

  /// ### 로그인 버튼 클릭
  ///
  /// #### Notes
  ///
  /// - 사용자가 로그인 버튼을 클릭하면 호출됩니다.
  /// - [SignInModel]에 저장된 사용자 정보를 서버로 전송합니다.
  /// - 사용자 정보가 올바르면, 유저 정보를 저장하고 메인 페이지로 이동합니다.
  /// - 사용자 정보가 올바르지 않으면, 에러 메시지를 표시합니다.
  ///
  /// #### Parameters
  ///
  /// - `BuildContext`: 빌드 컨텍스트
  ///
  /// #### Returns
  ///
  /// - `VoidCallback?(BuildContext)` : 로그인 버튼 클릭 시 호출할 콜백 함수
  ///
  VoidCallback? loginButtonOnClick(BuildContext context) {
    if (!canLogin) {
      // 로그인이 가능한 상태가 아니므로 null 반환
      return null;
    }
    return () async {
      // 로그인 버튼 클릭 시 호출할 콜백 함수
      final result = await login();

      if (result) {
        // 로그인 성공 시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 성공'),
          ),
        );
      } else {
        // 로그인 실패 시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패했습니다.'),
          ),
        );
      }
    };
  }

  /// ### 로그인 수행 함수
  ///
  /// #### Notes
  ///
  /// - 사용자가 로그인 버튼을 클릭하면 호출됩니다.
  /// - [SignInModel]에 저장된 사용자 정보를 서버로 전송합니다.
  ///
  /// #### Returns
  ///
  /// [Future<bool>] : 로그인 성공 여부 (true: 성공, false: 실패)
  ///
  Future<bool> login() async {
    final json = {
      "userPheonNumber": getSignInModel.userPhoneModel.phoneNumber,
      "diaCode": getSignInModel.userPhoneModel.dialCode,
      "userID": getSignInModel.userIDModel.userID,
      "userPassword": getSignInModel.userPasswordModel.userPassword,
    };

    // 서버로 사용자 정보 전송
    final response = await HttpService.post('/user/login', json);

    // 로그인 성공 여부 반환
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final userDetailInfo =
          UserDetailInfoModel.fromJson(decodedJson['userInfo']);
      ref.read(userDetailInfoStateProvider.notifier).update(userDetailInfo);
      return true;
    } else {
      return false;
    }
  }
}
