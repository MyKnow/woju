import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_phone_model.dart';
import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

/// ### signInStateProvider
///
/// #### Notes
///
/// - autoDispose 속성을 가지므로, 해당 Provider가 더 이상 필요 없을 때 자동으로 해제됨
/// - [SignInStateNotifier] 로그인 상태를 관리하는 StateNotifier
///
final signInStateProvider =
    StateNotifierProvider.autoDispose<SignInStateNotifier, SignInModel>(
  (ref) => SignInStateNotifier(ref),
);

/// ### SignInStateNotifier
///
/// - 로그인 상태를 관리하는 StateNotififer
///
/// #### Fields
///
/// - [SignInModel] state: 로그인 상태 모델
/// - [Ref] ref: Ref 객체
///
/// #### Methods
///
/// - [void] [changeLoginMethod] (): 로그인 방법 변경 메서드
/// - [void] [updateCountryCode] ([String] dialCode, [String] isoCode): 국가 코드 업데이트 메서드
/// - [void] [updatePhoneNumber] ([String] phoneNumber): 전화번호 업데이트 메서드
/// - [void] [updatePassword] ([String] password): 비밀번호 업데이트 메서드
/// - [void] [togglePasswordVisibility] (): 비밀번호 가리기/보이기 토글 메서드
/// - [void] [updateUserID] ([String] userID): 아이디 업데이트 메서드
/// - [void] [clearPhoneNumber] (): 전화번호 초기화 메서드
/// - [void] [clearUserID] (): 아이디 초기화 메서드
/// - [void] [updateSignInStatus] ([SignInStatus] signInStatus): 로그인 상태 업데이트 메서드
/// - [SignInModel] get [getSignInModel]: 로그인 상태 모델 반환 메서드
/// - [bool] get [canLogin]: 로그인 가능 여부 반환 메서드
///
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
      userPasswordModel: state.userPasswordModel.copyWith(
        isPasswordVisible: !state.userPasswordModel.isPasswordVisible,
      ),
    );
  }

  void updateUserID(String userID) {
    state = state.copyWith(
      userIDModel: state.userIDModel.copyWith(userID: userID),
    );
  }

  void clearPhoneNumber() {
    state = state.copyWith(
      userPhoneModel: UserPhoneModel.initial(),
    );
  }

  void clearUserID() {
    state = state.copyWith(
      userIDModel: UserIDModel.initial(),
    );
  }

  /// ### 로그인 상태 업데이트
  ///
  /// #### Notes
  ///
  /// - signInStateProvider는 autoDispose로 생성되었으므로, signInStatus를 따로 두어 로그인 상태를 관리함
  ///
  /// #### Parameters
  ///
  /// - `SignInStatus`: 로그인 상태
  ///
  void updateSignInStatus(SignInStatus signInStatus) {
    ref.read(appStateProvider.notifier).updateSignInStatus(signInStatus);
  }

  SignInModel get getSignInModel => state;

  bool get canLogin =>
      (state.userPhoneModel.isPhoneNumberValid ||
          state.userIDModel.isIDValid) &&
      state.userPasswordModel.isPasswordAvailable;
}

/// ### SignInAction
///
/// - [SignInStateNotifier] 로그인 관련 메서드 확장
///
/// #### Methods
///
/// - [void] onClickChangeLoginMethodButton(): 로그인 방법 변경 버튼 클릭
/// - [void] onClickCountryChangeButton([CountryCode]? countryCode): 국가 코드 변경
/// - [void] onChangePhoneNumberField([String] phoneNumber): 전화번호 입력 OnChange 메서드
/// - [void] onChangePasswordField([String] password): 비밀번호 입력 OnChange 메서드
/// - [void] onClickPasswordVisibilityButton(): 비밀번호 가리기/보이기 버튼 클릭
/// - [void] onChangeUserIDField([String] userID): 아이디 입력 OnChange 메서드
/// - [VoidCallback]? onClickLoginButton([BuildContext] context): 로그인 버튼 클릭
/// - [VoidCallback]? onClickWithdrawalButton([BuildContext] context): 탈퇴 버튼 클릭
///
extension SignInAction on SignInStateNotifier {
  /// ### 로그인 방법 변경 버튼 클릭
  /// - 로그인 방법을 변경합니다.
  ///
  /// #### Notes
  /// - 로그인 방법을 변경합니다.
  /// - 로그인 방법이 변경되면, [loginWithPhoneNumber] 값이 변경됩니다.
  /// - [loginWithPhoneNumber] 값이 `true`이면, 전화번호로 로그인합니다.
  /// - [loginWithPhoneNumber] 값이 `false`이면, 아이디로 로그인합니다.
  /// - 방법을 변경할 때 전화번호 또는 아이디 입력 필드를 초기화합니다.
  ///
  void onClickChangeLoginMethodButton() {
    if (getSignInModel.loginWithPhoneNumber) {
      clearPhoneNumber();
    } else {
      clearUserID();
    }
    changeLoginMethod();
  }

  /// ### 국가 코드 변경
  ///
  /// #### Notes
  ///
  /// - 사용자가 국가 코드를 변경하면 호출됩니다.
  /// - 국가 코드를 변경합니다.
  ///
  /// #### Parameters
  ///
  /// - `CountryCode?`: 국가 코드
  ///
  void onClickCountryChangeButton(CountryCode? countryCode) {
    if (countryCode == null) {
      return;
    } else {
      if (countryCode.dialCode != null && countryCode.code != null) {
        final dialCode = countryCode.dialCode as String;
        final isoCode = countryCode.code as String;
        updateCountryCode(dialCode, isoCode);
      }
    }
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
  void onChangePhoneNumberField(String phoneNumber) {
    updatePhoneNumber(phoneNumber);
    printd("phoneNumber: ${getSignInModel.userPhoneModel.phoneNumber}");
    printd("id: ${getSignInModel.userIDModel.userID}");
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
  void onChangePasswordField(String password) {
    updatePassword(password);
  }

  /// ### 비밀번호 가리기/보이기 버튼 클릭
  ///
  /// #### Notes
  ///
  /// - 사용자가 비밀번호 가리기/보이기 버튼을 클릭하면 호출됩니다.
  ///
  void onClickPasswordVisibilityButton() {
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
  void onChangeUserIDField(String userID) {
    updateUserID(userID);
    printd("phoneNumber: ${getSignInModel.userPhoneModel.phoneNumber}");
    printd("id: ${getSignInModel.userIDModel.userID}");
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
  VoidCallback? onClickLoginButton(BuildContext context) {
    if (!canLogin) {
      // 로그인이 가능한 상태가 아니므로 null 반환
      return null;
    }

    return () async {
      final result = await UserService.login(
        getSignInModel.userPhoneModel.phoneNumber,
        getSignInModel.userPasswordModel.userPassword,
        getSignInModel.userPhoneModel.dialCode,
        getSignInModel.userPhoneModel.isoCode,
        getSignInModel.userIDModel.userID,
        ref,
      );

      if (result == SignInStatus.loginSuccess) {
        // 로그인 성공 시 로그인 상태 업데이트하여 goRouterProvider가 리다이렉트하도록 함
        updateSignInStatus(result);
        final user =
            await ref.read(userDetailInfoStateProvider.notifier).read();

        final userName = user?.userNickName ?? "";

        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
            result.toMessage,
            context,
            namedArgs: {"nickname": userName},
          );
        }
      } else {
        // 로그인 실패 시 에러 메시지 표시
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(result.toMessage, context,
              isLocalize: false);
        }
      }
    };
  }

  /// ### 탈퇴 버튼 클릭
  ///
  /// #### Notes
  ///
  /// - 사용자가 탈퇴 버튼을 클릭하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - `BuildContext`: 빌드 컨텍스트
  ///
  /// #### Returns
  ///
  /// - `VoidCallback?(BuildContext)` : 탈퇴 버튼 클릭 시 호출할 콜백 함수
  ///
  VoidCallback? onClickWithdrawalButton(BuildContext context) {
    return () async {
      final result = await withdrawal();

      if (result) {
        // 탈퇴 성공 시 signInStatus를 logout로 업데이트하여 goRouterProvider가 리다이렉트하도록 함
        await ref.read(userDetailInfoStateProvider.notifier).delete();
        await SecureStorageService.deleteSecureData(SecureModel.userPassword);
        updateSignInStatus(SignInStatus.logout);
      } else {
        // 탈퇴 실패 시 에러 메시지 표시
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
            SignInStatus.withDrawalFailed.toMessage,
            context,
            isLocalize: false,
          );
        }
      }
    };
  }

  /// ### 탈퇴 수행 함수
  ///
  /// #### Notes
  ///
  /// - 사용자가 탈퇴 버튼을 클릭하면 호출됩니다.
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 탈퇴 성공 여부 (true: 성공, false: 실패)
  ///
  Future<bool> withdrawal() async {
    final json = {
      "userID": ref.read(userDetailInfoStateProvider)?.userID,
      "userPassword":
          await SecureStorageService.readSecureData(SecureModel.userPassword),
    };

    printd("withdrawal: $json");

    // 서버로 사용자 정보 전송
    final response = await HttpService.userPost('/user/withdraw', json);

    // 탈퇴 성공 여부 반환
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// ### 로그아웃 수행 함수
  ///
  /// #### Notes
  ///
  /// - 로그아웃을 수행하고, 로그인 상태를 업데이트합니다.
  ///
  void logout() async {
    // 자동 로그인을 위한 SecureStorage 데이터 삭제
    await SecureStorageService.deleteSecureData(SecureModel.userPassword);

    // UserDetailInfoModel 업데이트
    await ref.read(userDetailInfoStateProvider.notifier).delete();

    // 로그인 상태 업데이트
    updateSignInStatus(SignInStatus.logout);
  }

  void resetPasswordButtonOnClick(BuildContext context) {
    context.push('/onboarding/signin/resetPassword');
  }
}
