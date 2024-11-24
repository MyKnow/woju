import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:woju/model/onboarding/sign_up_model.dart';
import 'package:woju/model/server_state_model.dart';
import 'package:woju/model/user/user_auth_model.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_phone_model.dart';

import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/provider/textfield_focus_state_notifier.dart';

import 'package:woju/service/debug_service.dart';
import 'package:woju/service/device_info_service.dart';
import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/toast_message_service.dart';

/// ### 회원가입 페이지의 StateNotifier Provider
///
/// - 회원가입 페이지의 상태를 관리한다.
///
/// - 회원가입 페이지의 Action을 확장하는 Extension을 포함한다.
///
final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpStateNotifier, SignUpModel>(
  (ref) => SignUpStateNotifier(ref),
);

/// ### SignUpStateNotifier
///
/// - 회원가입 페이지의 상태를 관리한다.
///
/// #### Fields
///
/// - [SignUpModel] state: 회원가입 상태 모델
/// - [FirebaseAuth] _firebaseAuth: FirebaseAuth 인스턴스
/// - [Ref] ref: Provider를 사용하기 위한 ref
///
/// #### Methods
///
/// - [void] [updatePhoneNumber] ([String] phoneNumber): 전화번호 업데이트 메서드
/// - [void] [updateCountryCode] ([String] dialCode, [String] isoCode): 국가 코드 업데이트 메서드
/// - [void] [updateUserAuthModel] ({[String]? authCode, [String]? verificationId, [String]? userUid, [int]? resendToken, [bool]? authCodeSent, [bool]? authCompleted, [bool]? isClear}): 사용자 인증 모델 업데이트 메서드
/// - [void] [updateError] ([String]? error): 에러 업데이트 메서드
/// - [void] [updateUserID] ([String] userID): 아이디 업데이트 메서드
/// - [void] [updateIDAvailable] ([bool] isIDAvailable): 아이디 가능 여부 업데이트 메서드
/// - [void] [updatePassword] ([String] password): 비밀번호 업데이트 메서드
/// - [void] [updatePasswordVisible] ([bool] isPasswordVisible): 비밀번호 가리기/보이기 토글 메서드
/// - [void] [updatePasswordAvailable] ([bool] isPasswordAvailable): 비밀번호 가능 여부 업데이트 메서드
/// - [void] [updateNickName] ([String] nickName): 닉네임 업데이트 메서드
/// - [void] [updateProfileImage] ([XFile]? profileImage): 프로필 이미지 업데이트 메서드
/// - [void] [updateGender] ([Gender] gender): 성별 업데이트 메서드
/// - [void] [updateBirthDate] ([DateTime]? birthDate): 생년월일 업데이트 메서드
/// - [void] [errorReset] (): 에러 상태 초기화 메서드
/// - [void] [updateTermsAgree] ([bool] termsAgree): 이용약관 동의 여부 업데이트 메서드
/// - [void] [updatePrivacyAgree] ([bool] privacyAgree): 개인정보 처리방침 동의 여부 업데이트 메서드
/// - [SignUpModel] get [getSignUpModel]: 회원가입 상태 모델 반환 메서드
///
class SignUpStateNotifier extends StateNotifier<SignUpModel> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Ref ref;

  SignUpStateNotifier(this.ref) : super(SignUpModel.initial());

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updatePhoneNumberAvailable(bool? isPhoneNumberValid) {
    if (isPhoneNumberValid == null) {
      printd("isPhoneNumberValid is null");
      state = state.copyWith(isPhoneNumberAvailableSetToDefault: true);
      return;
    }
    state = state.copyWith(isPhoneNumberAvailable: isPhoneNumberValid);
  }

  void updateCountryCode(String isoCode, String dialCode) {
    state = state.copyWith(isoCode: isoCode, dialCode: dialCode);
  }

  void updateUserAuthModel({
    String? authCode,
    String? verificationId,
    String? userUid,
    int? resendToken,
    bool? authCodeSent,
    bool? authCompleted,
    bool? isClear,
  }) {
    if (isClear == true) {
      state = state.copyWith(
        userAuthModel: UserAuthModel.initial(),
      );
      return;
    }
    state = state.copyWith(
        userAuthModel: state.userAuthModel.copyWith(
      authCode: authCode ?? state.userAuthModel.authCode,
      verificationId: verificationId ?? state.userAuthModel.verificationId,
      userUid: userUid ?? state.userAuthModel.userUid,
      resendToken: resendToken ?? state.userAuthModel.resendToken,
      authCodeSent: authCodeSent ?? state.userAuthModel.authCodeSent,
      authCompleted: authCompleted ?? state.userAuthModel.authCompleted,
    ));
  }

  void updateError(String? error) {
    state = state.copyWith(error: error);
  }

  void updateUserID(String userID) {
    state = state.copyWith(userID: userID);
  }

  void updateIDAvailable(bool isIDAvailable) {
    state = state.copyWith(isIDAvailable: isIDAvailable);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updatePasswordVisible(bool isPasswordVisible) {
    state = state.copyWith(isPasswordVisible: isPasswordVisible);
  }

  void updatePasswordAvailable(bool isPasswordAvailable) {
    state = state.copyWith(isPasswordAvailable: isPasswordAvailable);
  }

  void updateNickName(String nickName) {
    state = state.copyWith(userNickName: nickName);
  }

  void updateProfileImage(XFile? profileImage) {
    if (profileImage == null) {
      printd("profileImage is null");
      state =
          state.copyWith(profileImage: null, isProfileImageSetToDefault: true);
      return;
    }
    state = state.copyWith(profileImage: profileImage);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void updateBirthDate(DateTime? birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  /// ### 에러 상태 초기화 메서드
  ///
  void errorReset() {
    updateError(null);
  }

  /// ### 약관 동의 여부 업데이트 메서드
  ///
  /// - 약관 동의 여부를 업데이트한다.
  ///
  /// #### Parameters
  ///
  /// - [bool] termsAgree: 이용약관 동의 여부
  ///
  void updateTermsAgree(bool termsAgree) {
    state = state.copyWith(termsAgree: termsAgree);
  }

  /// ### 개인정보 처리방침 동의 여부 업데이트 메서드
  ///
  /// - 개인정보 처리방침 동의 여부를 업데이트한다.
  ///
  /// #### Parameters
  ///
  /// - [bool] privacyAgree: 개인정보 처리방침 동의 여부
  ///
  void updatePrivacyAgree(bool privacyAgree) {
    state = state.copyWith(privacyAgree: privacyAgree);
  }

  SignUpModel get getSignUpModel => state;
}

/// ### SignUpAction
///
/// - 회원가입 페이지에서의
///
/// #### Methods
///
/// - [void] [initStateEnterSignUpPage] ([BuildContext] context): 회원가입 페이지 진입 메서드
/// - [VoidCallback]? [onChangedCountryCode] ([CountryCode] countryCode): 국가 코드 변경 메서드
/// - Future<[void]> [sendAuthCodeMethod] (): 전화번호로 인증번호를 전송하는 메서드
/// - Future<[bool]> [verifyAuthCodeMethod] (): 인증번호 확인 메서드
/// - [VoidCallback]? [onClickVerifyAuthCodeButton] (): 인증번호 확인 버튼 활성화 여부 확인 메서드
/// - [VoidCallback]? [onClickSendAuthCodeButton] (): 인증번호 전송 버튼 활성화 여부 확인 메서드
/// - [void] [showToastMessage] (): Toast 메시지 출력 메서드
/// - [void] [onClickChangePhoneNumberButton] (): 번호 변경 메서드
/// - [VoidCallback]? [onClickResendAuthCodeButton] (): 인증번호 재전송 버튼 활성화 여부 확인 메서드
/// - Future<[bool]> [checkSignUpMethod] (): 회원가입 유무 확인 메서드
/// - [VoidCallback]? [onClickNextPageButton] (): 다음 버튼 활성화 여부 확인 메서드
/// - [void] [onChangePhoneNumberField] ([String] phoneNumber): 전화번호 변경 메서드
/// - [VoidCallback]? [checkAvailableIDButtonMethod] (): 아이디 중복 확인 버튼 활성화 여부 확인 메서드
/// - [void] [onClickModifyIDButton] (): 아이디 수정 메서드
/// - [void] [onClickChangePasswordVisibilityButton] (): 비밀번호 가리기/보이기 토글 메서드
/// - [void] [onChangePasswordField] ([String] password): 비밀번호 변경 메서드
/// - [void] [onClickPushPolicyPageButton] (): 이용약관 및 개인정보 처리방침 페이지 이동 메서드
/// - [void] [onClickAgreePolicyButton] ([BuildContext] context, [String] policyType): 이용약관 및 개인정보 처리방침 동의 버튼 메서드
/// - Future<[Map<String, dynamic>]> [getPolicyContentMethod] ([BuildContext] context, [String] policyType): 이용약관 및 개인정보 처리방침 내용 가져오기 메서드
/// - [void] [onClickTermsAgreeButton] ([bool]? isAgree): 이용약관 동의 버튼 메서드
/// - [void] [onClickPrivacyAgreeButton] ([bool]? isAgree): 개인정보 처리방침 동의 버튼 메서드
///
extension SignUpAction on SignUpStateNotifier {
  /// ### 회원가입 페이지 진입 메서드
  ///
  /// - 회원가입 페이지 진입 후 초기화를 진행한다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] context: BuildContext
  ///
  /// #### Returns
  ///
  /// - [void] 회원가입 페이지 진입 메서드
  ///
  void initStateEnterSignUpPage(BuildContext context) async {
    printd("enterSignUpPage");
  }

  /// ### CountryCodePicker onChanged 메서드
  ///
  /// - 국가 코드를 변경하면 실행된다.
  ///
  /// #### Parameters
  ///
  /// - [CountryCode] countryCode: 국가 코드
  ///
  /// #### Returns
  ///
  /// - Function: 국가 코드 변경 메서드
  ///
  VoidCallback? onChangedCountryCode(CountryCode countryCode) {
    if (countryCode.code == null && countryCode.dialCode == null) {
      printd("countryCode is null");
      return null;
    }
    return () {
      final dialCode = countryCode.dialCode as String;
      final code = countryCode.code as String;

      printd("countryCode: $code, dialCode: $dialCode");

      updateCountryCode(code, dialCode);
    };
  }

  /// ### 전화번호로 인증번호를 전송하는 메서드
  ///
  /// - State에서 [getPhoneNumberWithFormat]을 통해 포맷화된 전화번호를 가져와 인증번호를 전송한다.
  ///
  Future<void> sendAuthCodeMethod() async {
    final nowPhoneNumber =
        getSignUpModel.userPhoneModel.getPhoneNumberWithFormat();
    final nowDialCode = getSignUpModel.userPhoneModel.dialCode;
    if (nowPhoneNumber == null || nowPhoneNumber.isEmpty) {
      printd("전화번호 입력 필요");
      updateError(PhoneNumberStatus.lengthInvalid.toMessage);
      return;
    }
    if (nowDialCode.isEmpty) {
      printd("국가 코드 입력 필요");
      updateError(PhoneNumberStatus.countrycodeEmpty.toMessage);
      return;
    }

    // 국가 코드 추가
    final codedPhoneNumber = "$nowDialCode$nowPhoneNumber";
    printd("전화번호: $codedPhoneNumber");

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: codedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        printd("인증 성공");
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          printd('전화번호 형식이 잘못되었습니다.');
          updateError(PhoneNumberStatus.invalid.toMessage);
          showToastMessage();
          return;
        }
        printd('인증 실패: ${e.message}');
        updateError(SignUpError.authCodeNotSent.toMessage);
        showToastMessage();
      },
      codeSent: (String verificationId, int? resendToken) {
        printd('인증번호 전송됨');
        updatePhoneNumber(nowPhoneNumber);
        updateUserAuthModel(
          verificationId: verificationId,
          resendToken: resendToken,
          authCodeSent: true,
        );
        ref.read(textfieldFocusStateProvider(4).notifier).nextFocusNodeMethod();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        printd('인증번호 입력 시간 초과');
        updateError(SignUpError.authCodeTimeout.toMessage);
        showToastMessage();
      },
      forceResendingToken: getSignUpModel.userAuthModel.resendToken,
    );
  }

  /// ### 인증번호 확인 메서드
  ///
  /// 사용자가 입력한 인증번호와 verificationId를 통해 인증을 확인한다.
  ///
  /// #### Parameters
  ///
  /// [String] authCode: 인증번호
  ///
  /// #### Returns
  ///
  /// [bool] 인증 성공 여부
  ///
  Future<bool> verifyAuthCodeMethod() async {
    final String authCode = getSignUpModel.userAuthModel.authCode ?? "";
    printd("verifyAuthCode: $authCode");
    if (authCode.isEmpty) {
      printd("인증번호 입력 필요");
      updateError(SignUpError.authCodeEmpty.toMessage);
      showToastMessage();
      return false;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: getSignUpModel.userAuthModel.verificationId ?? "",
        smsCode: authCode,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      printd("인증 성공: ${result.user?.uid}");
      printd("인증 성공: ${result.user?.phoneNumber}");
      updateUserAuthModel(userUid: result.user?.uid);

      // 백엔드로 인증 정보 전송하여 가입 유무 확인
      return checkSignUpMethod();
    } catch (e) {
      printd("인증 실패: $e");
      updateError(SignUpError.authCodeInvalid.toMessage);
      showToastMessage();
      return false;
    }
  }

  /// ### 인증번호 확인 함수 반환 메서드
  ///
  /// 사용자가 인증번호 확인 버튼을 누를 수 있는 지 확인하고, 확인을 진행한다.
  ///
  /// #### Returns
  ///
  /// Function: 인증번호 확인 함수 반환 메서드
  ///
  VoidCallback? onClickVerifyAuthCodeButton() {
    if (!getSignUpModel.userAuthModel.authCodeSent ||
        getSignUpModel.userAuthModel.authCompleted) {
      return null;
    }

    if (getSignUpModel.userAuthModel.authCode == null ||
        getSignUpModel.userAuthModel.authCode!.length < 6) {
      return null;
    }

    return () async {
      printd("verifyAuthCodeButton");
      final bool isVerified = await verifyAuthCodeMethod();
      if (isVerified) {
        updateUserAuthModel(authCompleted: true);
        ref.read(textfieldFocusStateProvider(4).notifier).nextFocusNodeMethod();
      } else {
        updateUserAuthModel(authCompleted: false);
        ref.read(textfieldFocusStateProvider(4).notifier).setFocusNode(2);
      }
    };
  }

  /// ### 인증번호 전송 메서드
  ///
  /// 사용자가 인증번호 전송 버튼을 누를 수 있는 지 확인하고, 전송을 진행한다.
  ///
  /// #### Returns
  ///
  /// Function: 인증번호 전송 메서드
  ///
  VoidCallback? onClickSendAuthCodeButton() {
    if (getSignUpModel.userPhoneModel.isPhoneNumberValid == false ||
        getSignUpModel.userAuthModel.authCodeSent == true ||
        getSignUpModel.termsAgree == false ||
        getSignUpModel.privacyAgree == false) {
      return null;
    }
    return () {
      printd("sendAuthCodeButton");
      sendAuthCodeMethod();
    };
  }

  //// ### Toast 메시지 출력 메서드
  ///
  /// 상태에 따른 Toast 메시지를 출력한다.
  ///
  /// #### Returns
  ///
  /// Function: Toast 메시지 출력 메서드
  ///
  void showToastMessage() {
    final String? errorMessage = getSignUpModel.error;
    if (errorMessage != null) {
      ToastMessageService.show(errorMessage);
    }
  }

  /// ### 번호 변경 메서드
  ///
  /// 사용자가 인증번호를 발송할 번호를 변경하기 위해 버튼을 누르면 실행된다.
  ///
  void onClickChangePhoneNumberButton() {
    printd("changePhoneNumber");
    updateUserAuthModel(isClear: true);
  }

  /// ### 인증번호 재전송 메서드
  ///
  /// 사용자가 인증번호를 재전송하기 위해 버튼을 누르면 실행된다.
  ///
  /// #### Returns
  ///
  /// Function: 인증번호 재전송 메서드
  ///
  VoidCallback? onClickResendAuthCodeButton() {
    if (!getSignUpModel.userAuthModel.authCodeSent ||
        getSignUpModel.userAuthModel.authCompleted) {
      return null;
    }
    return () {
      printd("resendAuthCodeButton");
      updateUserAuthModel(authCodeSent: false);
      sendAuthCodeMethod();
      ref.read(textfieldFocusStateProvider(4).notifier).nextFocusNodeMethod();
    };
  }

  /// ### 회원가입 유무 확인 메서드
  ///
  /// 백엔드로 전화번호 및 uid를 전송하여 DB 상에 존재하는지 확인한다.
  ///
  /// #### Returns
  ///
  /// [bool] 회원가입 여부
  ///
  Future<bool> checkSignUpMethod() async {
    final json = {
      "userDeviceID": await DeviceInfoService.getDeviceId(),
      "userPhoneNumber": getSignUpModel.userPhoneModel.phoneNumber,
      "dialCode": getSignUpModel.userPhoneModel.dialCode,
      "isoCode": getSignUpModel.userPhoneModel.isoCode,
    };

    // 백엔드로 전화번호 및 uid 전송
    try {
      final response =
          await HttpService.userPost("/user/check-phonenumber-available", json);

      printd("checkSignUp: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        printd("data: $data");
        if (data["isAvailable"] == false ||
            data["isAlreadyRegistered"] == true) {
          printd("회원가입된 사용자");
          updatePhoneNumberAvailable(false);
          updateUserAuthModel(authCodeSent: false);
          updateError(PhoneNumberStatus.notAvailable.toMessage);
          showToastMessage();
          return false;
        } else {
          printd("회원가입되지 않은 사용자");
          updatePhoneNumberAvailable(true);
          return true;
        }
      } else if (response.statusCode == 400) {
        printd("이미 가입된 사용자");
        updatePhoneNumberAvailable(false);
        updateError(PhoneNumberStatus.notAvailable.toMessage);
        showToastMessage();
        onClickChangePhoneNumberButton();
        return false;
      } else {
        printd("회원가입 여부 확인 실패 : ${response.statusCode}");
        updatePhoneNumberAvailable(null);
        updateError(ServerStatus.error.toMessage);
        showToastMessage();
        return false;
      }
    } catch (e) {
      printd("회원가입 여부 확인 실패 (json Error): $e");
      updatePhoneNumberAvailable(null);
      updateError(ServerStatus.error.toMessage);
      showToastMessage();
      return false;
    }
  }

  /// ### 다음 페이지 이동 버튼 활성화 여부 확인 메서드
  ///
  /// 인증을 완료하고 다음 페이지로 이동하는 함수를 상태에 따라 반환한다.
  ///
  /// #### Parameters
  ///
  /// [WidgetRef] ref: Provider를 사용하기 위한 ref
  /// [BuildContext] context: BuildContext
  ///
  /// #### Returns
  ///
  /// [VoidCallback] 다음 페이지 이동 버튼 활성화 여부 확인 메서드
  ///
  VoidCallback? onClickNextPageButton(BuildContext context) {
    if (!getSignUpModel.userAuthModel.authCompleted ||
        !getSignUpModel.userIDModel.isIDAvailable ||
        !getSignUpModel.userPasswordModel.isPasswordAvailable) {
      return null;
    }
    return () {
      printd("nextButton");
      ref.read(appStateProvider.notifier).pushRouteSignUpDetailPage(context);
    };
  }

  /// ### 전화번호 입력 필드 메서드
  ///
  /// 사용자가 전화번호를 입력할 때마다 실행된다.
  ///
  /// #### Parameters
  ///
  /// [String] phoneNumber: 전화번호
  ///
  void onChangePhoneNumberField(String phoneNumber) {
    updatePhoneNumber(phoneNumber);
  }

  /// ### 중복 ID 확인 메서드 버튼 활성화 여부 메서드
  ///
  /// 사용자가 ID 중복 확인 버튼을 누를 수 있는 지 확인하고, 확인을 진행한다.
  ///
  /// #### Returns
  ///
  /// Function: 중복 ID 확인 메서드
  ///
  VoidCallback? checkAvailableIDButtonMethod() {
    if (getSignUpModel.userIDModel.isIDAvailable) {
      printd("isIDAvailable: ${getSignUpModel.userIDModel.isIDAvailable}");
      return null;
    }

    if (UserIDModel.validateID(getSignUpModel.userIDModel.userID) !=
        UserIDStatus.validIDFormat) {
      printd(
          "validateID: ${UserIDModel.validateID(getSignUpModel.userIDModel.userID)}");
      return null;
    }

    if (getSignUpModel.userAuthModel.userUid == null ||
        getSignUpModel.userAuthModel.userUid!.isEmpty) {
      printd("userUid is null");
      return null;
    }

    return () async {
      printd("checkAvailableIDButton");
      final isAvailable = await UserIDModel.checkAvailableID(
          getSignUpModel.userIDModel.userID,
          getSignUpModel.userAuthModel.userUid);

      if (isAvailable == UserIDStatus.available) {
        updateIDAvailable(true);
        ref.read(textfieldFocusStateProvider(4).notifier).nextFocusNodeMethod();
      } else {
        updateIDAvailable(false);
        updateError(UserIDStatus.notAvailable.toMessage);
        showToastMessage();
        ref.read(textfieldFocusStateProvider(4).notifier).setFocusNode(3);
      }
    };
  }

  /// ### ID 변경 메서드
  ///
  /// 사용자가 ID를 변경하기 위해 버튼을 누르면 실행된다.
  ///
  void onClickModifyIDButton() {
    printd("isIDAvailable: ${getSignUpModel.userIDModel.isIDAvailable}");

    updateIDAvailable(false);
  }

  /// ### 비밀번호 가시성 변경 메서드
  ///
  /// 사용자가 비밀번호 가시성을 변경하기 위해 버튼을 누르면 실행된다.
  ///
  void onClickChangePasswordVisibilityButton() {
    printd("changePasswordVisibility");
    updatePasswordVisible(!getSignUpModel.userPasswordModel.isPasswordVisible);
  }

  /// ### 비밀번호 입력 필드 메서드
  ///
  /// 사용자가 비밀번호를 입력할 때마다 실행된다.
  ///
  /// #### Parameters
  ///
  /// [String] password: 비밀번호
  ///
  void onChangePasswordField(String password) {
    printd("updatePassword: $password");
    updatePassword(password);
  }

  /// ### 약관 페이지 이동 메서드
  ///
  /// 사용자가 약관 페이지로 이동하기 위해 버튼을 누르면 실행된다.
  ///
  /// #### Parameters
  /// - [BuildContext] context: BuildContext
  /// - [String] policyType: 약관 종류 (terms: 이용약관, privacy: 개인정보 처리방침)
  ///
  void onClickPushPolicyPageButton(BuildContext context, String policyType) {
    context.push('/onboarding/signup/policy/$policyType');
  }

  /// ### 약관 페이지에서 동의 버튼 클릭 메서드
  ///
  /// 사용자가 약관 페이지에서 동의 버튼을 클릭하면 실행된다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] context: BuildContext
  /// - [String] policyType: 약관 종류 (terms: 이용약관, privacy: 개인정보 처리방침)
  ///
  void onClickAgreePolicyButton(
      BuildContext context, String policyType, String version) {
    if (policyType == "terms" || policyType == "privacy") {
      printd("agree ${policyType}Button");
      if (policyType == "terms") {
        updateTermsAgree(true);
      } else {
        updatePrivacyAgree(true);
      }

      ToastMessageService.nativeSnackbar(
        "onboarding.signUp.${policyType}Agreement.page.agreeSuccess",
        context,
        namedArgs: {
          "date": DateFormat.yMMMd(context.locale.toString()).format(
            DateTime.now(),
          ),
        },
      );
      context.pop();
    }
  }

  /// ### 약관 Type에 따라 약관 내용과 버전 반환 메서드
  ///
  /// Type에 따라 서버에서 데이터를 읽어와, 약관 내용과 버전을 반환한다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] context: BuildContext
  /// - [String] policyType: 약관 종류 (terms: 이용약관, privacy: 개인정보 처리방침)
  ///
  /// #### Returns
  ///
  /// - [Future<Map<String, String>?>] : 약관 버전과 내용, 실패 시 null 반환
  ///
  Future<Map<String, String>?> getPolicyContentMethod(
      BuildContext context, String policyType) async {
    if (policyType != "terms" && policyType != "privacy") {
      return Future.value(null);
    }

    if (policyType == "terms") {
      policyType = "termsOfService";
    } else {
      policyType = "privacyPolicy";
    }

    String locale = context.locale.countryCode ?? "KR";
    if (locale != "KR" && locale != "US") {
      locale = "US";
    }

    final result = await HttpService.userGet(
        "/policy/terms?type=$policyType&country=$locale");

    if (result.statusCode == 200) {
      final data = jsonDecode(result.body);
      final version = data["version"];
      final content = data["content"];
      return {"version": version, "content": content};
    } else {
      return null;
    }
  }

  /// ### 이용약관 동의 메서드
  ///
  /// - 사용자가 이용약관에 동의할 때마다 실행된다.
  ///
  /// #### Note
  ///
  /// - 이용약관 버전을 업데이트한다.
  ///
  /// #### Parameters
  ///
  /// - [bool?] isAgree: 동의 여부
  ///
  void onClickTermsAgreeButton(bool? isAgree) {
    if (isAgree == true) {
      updateTermsAgree(true);
    } else {
      updateTermsAgree(false);
    }
  }

  /// ### 개인정보 처리방침 동의 메서드
  ///
  /// - 사용자가 개인정보 처리방침에 동의할 때마다 실행된다.
  ///
  /// #### Note
  ///
  /// - 개인정보 처리방침 버전을 업데이트한다.
  ///
  /// #### Parameters
  ///
  /// - [bool?] isAgree: 동의 여부
  ///
  void onClickPrivacyAgreeButton(bool? isAgree) {
    if (isAgree == true) {
      updatePrivacyAgree(true);
    } else {
      updatePrivacyAgree(false);
    }
  }
}

/// ### 회원가입 페이지의 유저 정보 입력 Action을 확장하는 Extension
///
/// - 유저 정보 입력 페이지에서 사용되는 Action을 확장한다.
///
/// #### Methods
///
/// - Future<[void]> [pickImage] ([bool] isGallery, [BuildContext] context): 이미지 가져오기 메서드
/// - [void] [onChangeNickNameField] ([String] nickName): 닉네임 변경 메서드
/// - [VoidCallback]? [onClickCompleteButton] ([BuildContext] context): 완료 버튼 활성화 여부 확인 메서드
/// - Future<[SignUpError]?> [signUpMethod] (): 회원가입 메서드
/// - [void] [onChangeGenderRadioButton] ([Gender]? gender): 성별 선택 메서드
/// - [void] [onChangeBirthDateWheel] ([DateTime] birthDate): 생년월일 선택 메서드
///
extension SignUpUserInfoAction on SignUpStateNotifier {
  /// ### ImagePickerService를 통해 이미지를 가져오는 메서드
  ///
  /// - 이미지를 가져오는 메서드
  ///
  /// #### Parameters
  ///
  /// - [bool] isGallery: 갤러리에서 이미지를 가져올지 여부 (true: 갤러리, false: 카메라)
  /// - [BuildContext] context: BuildContext
  ///
  /// #### Returns
  ///
  /// - [VoidCallback] 이미지 가져오기 메서드
  ///
  Future<void> pickImage(bool? isGallery, BuildContext context) async {
    Navigator.pop(context);
    if (isGallery == null) {
      printd("isGallery is null");
      updateProfileImage(null);
      return;
    }
    final XFile? image = isGallery
        ? await ImagePickerService().pickImageForGallery()
        : await ImagePickerService().pickImageForCamera();

    if (image != null) {
      updateProfileImage(image);
    }
  }

  /// ### 닉네임 입력 필드 메서드
  ///
  /// - 사용자가 닉네임을 입력할 때마다 실행된다.
  ///
  /// #### Parameters
  ///
  /// - [String] nickName: 닉네임
  ///
  void onChangeNickNameField(String nickName) {
    printd("updateNickName: $nickName");
    updateNickName(nickName);
  }

  /// ### 완료 버튼 활성화 여부 확인 메서드
  ///
  /// - 회원가입 페이지에서 완료 버튼을 누를 수 있는 지 확인하고, 확인을 진행한다.
  ///
  /// #### Returns
  ///
  /// - [VoidCallback] 완료 버튼 활성화 여부 확인 메서드
  ///
  /// - 완료 버튼을 누를 수 있으면 로그인 페이지로 이동한다.
  ///
  VoidCallback? onClickCompleteButton(BuildContext context) {
    if (!getSignUpModel.userPhoneModel.isPhoneNumberValid ||
        getSignUpModel.userPhoneModel.dialCode.isEmpty ||
        getSignUpModel.userPhoneModel.isoCode.isEmpty ||
        getSignUpModel.userAuthModel.userUid == null ||
        !getSignUpModel.userIDModel.isIDAvailable ||
        !getSignUpModel.userPasswordModel.isPasswordAvailable ||
        !getSignUpModel.userNickNameModel.isNicknameValid) {
      return null;
    }
    return () async {
      printd("completeButton");

      final result = await signUpMethod();

      if (result != null) {
        updateError(result.toMessage);
        showToastMessage();
        return;
      }

      if (context.mounted) {
        ToastMessageService.nativeSnackbar(
            "onboarding.signUp.detail.signUpSuccess", context);
        context.go('/onboarding/signin');
      }
    };
  }

  /// ### 완료 시 서버로 회원가입 정보 전송 메서드
  ///
  /// - 회원가입 정보를 서버로 전송한다.
  ///
  /// #### Returns
  ///
  /// - [SignUpError?] 에러 메시지
  ///
  /// - 회원가입 성공 시 null, 실패 시 에러 메시지 반환
  ///
  Future<SignUpError?> signUpMethod() async {
    final json = await getSignUpModel.toJson();

    // 백엔드로 회원가입 정보 전송
    try {
      final response = await HttpService.userPost("/user/signup", json);

      printd("signUp: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["isSuccess"] == true) {
          printd("회원가입 성공");
          return null;
        } else {
          printd("회원가입 실패");
          return SignUpError.signUpFailure;
        }
      } else {
        printd("회원가입 실패 : ${response.statusCode}");
        printd("회원가입 실패 : ${jsonDecode(response.body)["failureReason"]}");
        printd("회원가입 실패 : ${jsonDecode(response.body)["message"]}");

        if (response.statusCode == 400) {
          return SignUpError.signUpFailure;
        } else {
          return SignUpError.serverError;
        }
      }
    } catch (e) {
      printd("회원가입 실패 (json Error): $e");
      return SignUpError.serverError;
    }
  }

  /// ### 회원가입 페이지의 성별 선택 메서드
  ///
  /// - 사용자가 성별을 선택할 때마다 실행된다.
  ///
  /// #### Parameters
  ///
  /// [int] 성별: 0 - 비공개, 1 - 남성, 2 - 여성, 3 - 기타
  ///
  /// #### Returns
  ///
  /// [VoidCallback] 성별 선택 메서드
  ///
  void onChangeGenderRadioButton(Gender? gender) {
    if (gender == null) {
      return;
    }
    printd("Gender: $gender");
    updateGender(gender);
  }

  /// ### 생년월일 선택 메서드
  ///
  /// - 사용자가 생년월일을 선택할 때마다 실행된다.
  ///
  /// #### Parameters
  ///
  /// - [DateTime] birthDate: 생년월일
  ///
  /// #### Returns
  ///
  /// - [VoidCallback] 생년월일 선택 메서드
  ///
  void onChangeBirthDateWheel(DateTime birthDate) {
    printd("birthDate: $birthDate");
    updateBirthDate(birthDate);
    printd("birthDate: ${getSignUpModel.birthDate}");
  }
}
