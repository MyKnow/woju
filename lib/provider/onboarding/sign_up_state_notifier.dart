import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/onboarding/sign_up_model.dart';
import 'package:woju/provider/onboarding/onboarding_state_notifier.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/http_service.dart';
import 'package:woju/service/toast_message_service.dart';

final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpStateNotifier, SignUpModel>(
  (ref) => SignUpStateNotifier(ref),
);

class SignUpStateNotifier extends StateNotifier<SignUpModel> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Ref ref;
  SignUpStateNotifier(this.ref) : super(SignUpModel.initial());

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

  void updateIDValid(bool isIDValid) {
    state = state.copyWith(isIDValid: isIDValid);
  }

  void updateUserID(String userID) {
    state = state.copyWith(userID: userID);
  }

  void updateIDAvailable(bool isIDAvailable) {
    state = state.copyWith(isIDAvailable: isIDAvailable);
  }

  SignUpModel get getSignUpModel => state;
}

/// ### 회원가입 페이지의 Action을 확장하는 Extension
///
extension SignUpAction on SignUpStateNotifier {
  /// ### 전화번호로 인증번호를 전송하는 메서드
  ///
  /// - [PhoneNumber]을 통해 전화번호를 가져와 인증번호를 전송한다.
  ///
  /// #### Parameters
  ///
  /// [PhoneNumber] phoneNumberDetail: 전화번호 정보
  ///
  Future<void> verifyPhoneNumber() async {
    final nowPhoneNumber = getPhoneNumberWithoutHyphen();
    final nowDialCode = getSignUpModel.dialCode;
    if (nowPhoneNumber.isEmpty) {
      printd("전화번호 입력 필요");
      updateError(SignUpError.phoneNumberEmpty);
      return;
    }
    if (nowDialCode.isEmpty) {
      printd("국가 코드 입력 필요");
      updateError(SignUpError.isoCodeEmpty);
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
        ref.read(signUpAuthFocusProvider.notifier).requestFocusAuthCode();
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
    final String phoneNumber = getPhoneNumberWithoutHyphen(); // 전화번호에 - 제거
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
      updateUserUid(result.user?.uid ?? "");
      printd("인증 성공: ${result.user?.phoneNumber}");

      // 백엔드로 인증 정보 전송하여 가입 유무 확인
      return checkSignUp(phoneNumber, result.user?.uid ?? "");
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
    if (!getSignUpModel.authCodeSent || getSignUpModel.authCompleted) {
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
    if (!getSignUpModel.isPhoneNumberValid || getSignUpModel.authCodeSent) {
      return null;
    }
    return () {
      printd("sendAuthCodeButton");
      verifyPhoneNumber();
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
    printd("changePhoneNumber");
    updateAuthCodeSent(false);
    updateAuthCompleted(false);
    updateAuthCode("");
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
    if (!getSignUpModel.authCodeSent || getSignUpModel.authCompleted) {
      return null;
    }
    return () {
      printd("resendAuthCodeButton");
      updateAuthCodeSent(false);
      verifyPhoneNumber();
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
  Future<bool> checkSignUp(String? phoneNumber, String? verificationID) async {
    final json = {
      "userVerificationID": verificationID,
      "userPhoneNumber": phoneNumber,
    };

    // 백엔드로 전화번호 및 uid 전송
    try {
      final response =
          await HttpService.post("/user/check-phonenumber-available", json);

      printd("checkSignUp: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["exist"] == true) {
          printd("회원가입된 사용자");
          updateError(SignUpError.alreadySignedUp);
          showToastMessage();
          return false;
        } else {
          printd("회원가입되지 않은 사용자");
          return true;
        }
      } else {
        printd("회원가입 여부 확인 실패");
        updateError(SignUpError.serverError);
        showToastMessage();
        return false;
      }
    } catch (e) {
      printd("회원가입 여부 확인 실패 (json Error): $e");
      updateError(SignUpError.serverError);
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
  VoidCallback? nextButton(BuildContext context) {
    if (!getSignUpModel.authCompleted) {
      return null;
    }
    return () {
      printd("nextButton");
      ref
          .read(onboardingStateProvider.notifier)
          .pushRouteSignUpDetailPage(context);
    };
  }

  /// ### 전화번호에 -를 제거하여 String 반환하는 메서드
  ///
  /// 전화번호에 -를 제거하여 String을 반환한다.
  ///
  /// #### Returns
  ///
  /// [String] 전화번호
  ///
  String getPhoneNumberWithoutHyphen() {
    final phoneNumber = getSignUpModel.phoneNumber;
    return phoneNumber.replaceAll("-", "");
  }

  /// ### 전화번호 입력 필드 Validation 메서드
  ///
  /// 전화번호 입력 필드의 Validation을 진행한다.
  ///
  /// #### Parameters
  ///
  /// [String] phoneNumber: 전화번호
  ///
  /// #### Returns
  ///
  /// [String?] 에러 메시지
  ///
  /// - 에러가 없으면 null 반환
  ///
  String? phoneNumberValidation(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePhoneNumberValid(false);
      });
      return "onboarding.signUp.error.phoneNumberEmpty".tr();
    } else if (phoneNumber.length < 5 || phoneNumber.length > 15) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePhoneNumberValid(false);
      });
      return "onboarding.signUp.error.phoneNumberInvalid".tr();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePhoneNumberValid(true);
      });
      return null;
    }
  }
}

/// ### 회원가입 페이지의 유저 정보 입력 Action을 확장하는 Extension
///
/// - 유저 정보 입력 페이지에서 사용되는 Action을 확장한다.
///
extension SignUpUserInfoAction on SignUpStateNotifier {
  /// ### 유저 ID 입력 필드 Validation 메서드
  ///
  /// - 유저 ID 입력 필드의 Validation을 진행한다.
  ///
  /// #### Parameters
  ///
  /// - [String] userID: 유저 ID
  ///
  /// #### Returns
  ///
  /// - [String?] 에러 메시지
  ///
  /// - 에러가 없으면 null 반환
  ///
  String? userIDValidation(String? userID) {
    String? isError;
    if (userID == null || userID.isEmpty) {
      isError = "onboarding.signUp.detail.error.userIDEmpty".tr();
    } else if (userID.length < 4) {
      isError = "onboarding.signUp.detail.error.userIDShort".tr();
    } else if (userID.length > 20) {
      isError = "onboarding.signUp.detail.error.userIDLong".tr();
    }

    // 소문자가 제일 앞에 위치해야 함
    if (RegExp(r'^[a-z]').firstMatch(userID ?? "")?.start != 0) {
      isError =
          "onboarding.signUp.detail.error.userIDInvalidAlphabetFirst".tr();
    }
    // 소문자, 숫자만 입력 가능
    if (!RegExp(r'^[a-z0-9]*$').hasMatch(userID ?? "")) {
      isError = "onboarding.signUp.detail.error.userIDInvalid".tr();
    }
    // 소문자가 4개 이상 포함되어야 함
    if (RegExp(r'[a-z]').allMatches(userID ?? "").length < 4) {
      isError = "onboarding.signUp.detail.error.userIDInvalidAlphabet".tr();
    }

    // 유효성 검사 통과
    // TODO : userID valid check
    if (isError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateIDValid(true);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateIDValid(false);
      });
    }
    return isError;
  }

  /// ### ID 사용 가능 여부 메서드
  ///
  /// - 사용자가 입력한 ID가 중복되는지 서버의 DB와 비교하여 확인한다.
  ///
  /// #### Returns
  ///
  /// - [bool] ID 사용 가능 여부
  ///
  /// - 사용 가능하면 true, 중복되면 false 반환
  ///
  Future<bool> checkAvailableID() async {
    final json = {
      "userID": getSignUpModel.userID,
      "userUID": getSignUpModel.userUid,
    };

    // 백엔드로 ID 전송
    try {
      final response =
          await HttpService.post("/user/check-userid-available", json);

      printd("checkDuplicateID: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["isAvailable"] == true) {
          printd("사용 가능한 ID");
          return true;
        } else {
          printd("사용 불가능한 ID");
          updateError(SignUpError.userIDNotAvailable);
          showToastMessage();
          return false;
        }
      } else {
        printd("ID 중복 여부 확인 실패");
        updateError(SignUpError.serverError);
        return false;
      }
    } catch (e) {
      printd("ID 중복 여부 확인 실패 (json Error): $e");
      updateError(SignUpError.serverError);
      showToastMessage();
      return false;
    }
  }

  /// ### 중복 ID 확인 메서드 버튼 활성화 여부 메서드
  ///
  /// 사용자가 ID 중복 확인 버튼을 누를 수 있는 지 확인하고, 확인을 진행한다.
  ///
  /// #### Returns
  ///
  /// Function: 중복 ID 확인 메서드
  ///
  VoidCallback? checkAvailableIDButton() {
    if (getSignUpModel.isIDAvailable) {
      return null;
    }

    if (getSignUpModel.userID.isEmpty) {
      return null;
    }

    if (getSignUpModel.userUid == null || getSignUpModel.userUid!.isEmpty) {
      return null;
    }

    return () async {
      printd("checkAvailableIDButton");
      final bool isAvailable = await checkAvailableID();
      if (isAvailable) {
        updateIDAvailable(true);
      } else {
        updateIDAvailable(false);
        updateError(SignUpError.userIDNotAvailable);
        showToastMessage();
      }
    };
  }

  /// ### ID 변경 메서드
  ///
  /// 사용자가 ID를 변경하기 위해 버튼을 누르면 실행된다.
  ///
  void modifyIDButton() {
    printd("isIDAvailable: ${getSignUpModel.isIDAvailable}");

    updateIDAvailable(false);
  }
}

/// ### 회원가입 페이지의 전화번호 입력 컨트롤러 Provider
final phoneNumberTextEditingControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

/// ### 회원가입 페이지의 포커스 상태 Provider
///
/// - 포커스 상태를 관리한다.
///
final signUpAuthFocusProvider =
    StateNotifierProvider.autoDispose<SignUpAuthFocusNotifier, List<FocusNode>>(
  (ref) => SignUpAuthFocusNotifier(),
);

/// ### 회원가입 페이지의 FocusNode StateNotifier Provider
///
/// - 전화번호 입력 필드와 인증번호 입력 필드의 포커스를 관리한다.
///
class SignUpAuthFocusNotifier extends StateNotifier<List<FocusNode>> {
  SignUpAuthFocusNotifier() : super([FocusNode(), FocusNode()]);

  void requestFocusPhoneNumber() {
    state[0].requestFocus();
  }

  void requestFocusAuthCode() {
    state[1].requestFocus();
  }

  void unfocusPhoneNumber() {
    state[0].unfocus();
  }

  void unfocusAuthCode() {
    state[1].unfocus();
  }
}
