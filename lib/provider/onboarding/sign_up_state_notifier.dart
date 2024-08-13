import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:woju/model/sign_up_model.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/http_service.dart';
import 'package:woju/service/toast_message_service.dart';

final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpStateNotifier, SignUpModel>(
  (ref) => SignUpStateNotifier(),
);

class SignUpStateNotifier extends StateNotifier<SignUpModel> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SignUpStateNotifier() : super(SignUpModel.initial());

  void updateAuthCode(String authCode) {
    state = state.copyWith(authCode: authCode);
  }

  void updateAuthCodeSent(bool authCodeSent) {
    state = state.copyWith(authCodeSent: authCodeSent);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateIsoCode(String isoCode) {
    state = state.copyWith(isoCode: isoCode);
  }

  void updateDialCode(String dialCode) {
    state = state.copyWith(dialCode: dialCode);
  }

  void updateError(SignUpError? error) {
    state = state.copyWith(error: error);
  }

  void updateVerificationId(String verificationId) {
    state = state.copyWith(verificationId: verificationId);
  }

  void updateResendToken(int? resendToken) {
    state = state.copyWith(resendToken: resendToken);
  }

  void updatePhoneNumberValid(bool isPhoneNumberValid) {
    state = state.copyWith(isPhoneNumberValid: isPhoneNumberValid);
  }

  void updateAuthCompleted(bool authCompleted) {
    state = state.copyWith(authCompleted: authCompleted);
  }

  void updateUserUid(String uid) {
    state = state.copyWith(userUid: uid);
  }

  PhoneNumber get getPhoneNumberObject => state.getPhoneNumberObject;

  SignUpModel get getSignUpModel => state;
}

/// ### 회원가입 페이지의 Action을 확장하는 Extension
///
extension SignUpAction on SignUpStateNotifier {
  /// ### 인증번호를 전송하는 메서드
  ///
  /// - [PhoneNumber]을 통해 전화번호를 가져와 인증번호를 전송한다.
  ///
  /// #### Parameters
  ///
  /// [String] phoneNumber: 전화번호
  ///
  void sendAuthCode(String phoneNumberFromController) async {
    printd("sendAuthCodeWith : $phoneNumberFromController");
    PhoneNumber newPhoneNumberObject = PhoneNumber(
      phoneNumber: phoneNumberFromController,
      isoCode: getSignUpModel.isoCode,
      dialCode: getSignUpModel.dialCode,
    );
    await signInWithPhoneNumber(newPhoneNumberObject);
  }

  /// ### 전화번호로 인증번호를 전송하는 메서드
  ///
  /// - [PhoneNumber]을 통해 전화번호를 가져와 인증번호를 전송한다.
  ///
  /// #### Parameters
  ///
  /// [PhoneNumber] phoneNumberDetail: 전화번호 정보
  ///
  Future<void> signInWithPhoneNumber(PhoneNumber phoneNumberDetail) async {
    String phoneNumber = phoneNumberDetail.phoneNumber ?? "";
    final String isoCode = phoneNumberDetail.isoCode ?? "";
    if (phoneNumber.isEmpty) {
      printd("전화번호 입력 필요");
      updateError(SignUpError.phoneNumberEmpty);
      return;
    }
    if (isoCode.isEmpty) {
      printd("국가 코드 입력 필요");
      updateError(SignUpError.isoCodeEmpty);
      return;
    }

    if (phoneNumber.contains("-")) {
      printd("전화번호에 - 제거");
      phoneNumber = phoneNumber.replaceAll("-", "");
      printd("전화번호: $phoneNumber");
    }

    // 국가 코드 추가
    phoneNumber = "${phoneNumberDetail.dialCode}$phoneNumber";
    printd("전화번호: $phoneNumber");

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        printd("인증 성공");
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          printd('전화번호 형식이 잘못되었습니다.');
          updateError(SignUpError.phoneNumberInvalid);
          showToastMessage();
          return;
        }
        printd('인증 실패: ${e.message}');
        updateError(SignUpError.authCodeNotSent);
        showToastMessage();
      },
      codeSent: (String verificationId, int? resendToken) {
        printd('인증번호 전송됨');
        updateAuthCodeSent(true);
        printd("verificationId: $verificationId");
        printd("resendToken: $resendToken");
        updateVerificationId(verificationId);
        updateResendToken(resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        printd('인증번호 입력 시간 초과');
        updateError(SignUpError.authCodeTimeout);
        showToastMessage();
      },
      forceResendingToken: getSignUpModel.resendToken,
    );
  }

  /// ### 에러 상태 초기화 메서드
  ///
  void errorReset() {
    updateError(null);
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
  Future<bool> verifyAuthCode() async {
    final String authCode = getSignUpModel.authCode ?? "";
    printd("verifyAuthCode: $authCode");
    if (authCode.isEmpty) {
      printd("인증번호 입력 필요");
      updateError(SignUpError.authCodeEmpty);
      showToastMessage();
      return false;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: getSignUpModel.verificationId ?? "",
        smsCode: authCode,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      printd("인증 성공: ${result.user?.uid}");
      printd("인증 성공: ${result.user?.phoneNumber}");

      // 백엔드로 인증 정보 전송하여 가입 유무 확인
      return checkSignUp(getSignUpModel.phoneNumber, result.user?.uid ?? "");
    } catch (e) {
      printd("인증 실패: $e");
      updateError(SignUpError.authCodeInvalid);
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
  VoidCallback? verifyAuthCodeButton() {
    if (!getSignUpModel.authCodeSent) {
      return null;
    }

    if (getSignUpModel.authCode == null ||
        getSignUpModel.authCode!.length < 6) {
      return null;
    }

    return () async {
      printd("verifyAuthCodeButton");
      final bool isVerified = await verifyAuthCode();
      if (isVerified) {
        updateAuthCodeSent(false);
        updateAuthCompleted(true);
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
  VoidCallback? sendAuthCodeButton(String phoneNumber) {
    if (!getSignUpModel.isPhoneNumberValid) {
      return null;
    }
    return () {
      printd("sendAuthCodeButton");
      sendAuthCode(phoneNumber);
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
    final String? errorMessage = getSignUpModel.error?.message;
    if (errorMessage != null) {
      ToastMessageService.show(errorMessage);
    }
  }

  /// ### 번호 변경 메서드
  ///
  /// 사용자가 인증번호를 발송할 번호를 변경하기 위해 버튼을 누르면 실행된다.
  ///
  void changePhoneNumber() {
    updateAuthCodeSent(false);
  }

  /// ### 인증번호 재전송 메서드
  ///
  /// 사용자가 인증번호를 재전송하기 위해 버튼을 누르면 실행된다.
  ///
  /// #### Returns
  ///
  /// Function: 인증번호 재전송 메서드
  ///
  VoidCallback? resendAuthCodeButton(String phoneNumber) {
    if (!getSignUpModel.authCodeSent) {
      return null;
    }
    return () {
      printd("resendAuthCodeButton");
      updateAuthCodeSent(false);
      sendAuthCode(phoneNumber);
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
  Future<bool> checkSignUp(String? phoneNumber, String? uid) async {
    final json = {
      "userPhoneNumber": phoneNumber,
      "uid": uid,
    };

    // 백엔드로 전화번호 및 uid 전송
    final response = await HttpService.post("/check-exist-user", json);

    if (response["exist"] == true) {
      printd("회원가입된 사용자");
      return true;
    } else {
      printd("회원가입되지 않은 사용자");
      return false;
    }
  }
}

/// ### 회원가입 페이지의 전화번호 입력 컨트롤러 Provider
final phoneNumberTextEditingControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());
