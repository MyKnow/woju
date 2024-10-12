import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_auth_model.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/toast_message_service.dart';

final authStateProvider =
    StateNotifierProvider.autoDispose<AuthStateNotififer, UserAuthModel>(
  (ref) => AuthStateNotififer(ref),
);

/// ### AuthStateNotifier
///
/// - 인증 상태를 관리하는 Notifier
///
/// #### Fields
///
/// - [state]: 인증 상태 모델 (UserAuthModel)
/// - [_firebaseAuth]: FirebaseAuth 인스턴스
/// - [ref]: Ref
///
/// #### Methods
///
/// - [updateAuthCode]: 인증 코드 업데이트
/// - [updateVerificationId]: 인증 ID 업데이트
/// - [updateResendToken]: 재전송 토큰 업데이트
/// - [updateAuthCodeSent]: 인증 코드 전송 상태 업데이트
/// - [updateAuthCompleted]: 인증 완료 상태 업데이트
/// - [updateUserUid]: 유저 UID 업데이트
/// - [updateAuthStatus]: 인증 상태 업데이트
/// - [updateExistStatus]: 사용자 존재 상태 업데이트
/// - [reset]: 상태 초기화
/// - [getAuthModel]: 인증 상태 반환
///
class AuthStateNotififer extends StateNotifier<UserAuthModel> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final Ref ref;
  AuthStateNotififer(this.ref) : super(UserAuthModel.initial());

  void updateAuthCode(String authCode) {
    state = state.copyWith(authCode: authCode);
  }

  void updateVerificationId(String verificationId) {
    state = state.copyWith(verificationId: verificationId);
  }

  void updateResendToken(int? resendToken) {
    state = state.copyWith(resendToken: resendToken);
  }

  void updateAuthCodeSent(bool authCodeSent) {
    state = state.copyWith(authCodeSent: authCodeSent);
  }

  void updateAuthCompleted(bool authCompleted) {
    state = state.copyWith(authCompleted: authCompleted);
  }

  void updateUserUid(String userUid) {
    state = state.copyWith(userUid: userUid);
  }

  void updateAuthStatus(AuthStatus status) {
    state = state.copyWith(status: status);
  }

  void updateExistStatus(UserExistStatus? userExistStatus) {
    state = state.copyWith(userExistStatus: userExistStatus);
  }

  void reset() {
    state = UserAuthModel.initial();
  }

  UserAuthModel get getAuthModel => state;
}

/// ### AuthAction
///
/// - AuthStateNotifier를 활용하는 액션을 정의하는 Extension
///
/// #### Methods
///
/// - [verifyPhoneNumber]: 전화번호로 인증번호를 전송하는 메서드
/// - [verifyAuthCode]: 인증번호 확인 메서드
/// - [checkUserExist]: 사용자 존재 확인 메서드
///
extension AuthAction on AuthStateNotififer {
  /// ### 전화번호로 인증번호를 전송하는 메서드
  ///
  /// - State에서 [getPhoneNumberWithFormat]을 통해 전화번호를 가져와 인증번호를 전송한다.
  ///
  /// #### Parameters
  ///
  /// - [String phoneNumber] : 전화번호
  /// - [String dialCode] : 국가 코드
  /// - [Function focusNodeChange] : 포커스 노드 변경 함수
  ///
  Future<void> verifyPhoneNumber(
      String phoneNumber, String dialCode, VoidCallback focusNodeChange) async {
    if (phoneNumber.isEmpty || dialCode.isEmpty) return;

    // 전화번호의 앞자리가 0이라면 제거
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    // 전화번호에 - 제거
    phoneNumber = phoneNumber.replaceAll("-", "");

    // 국가 코드 추가
    final codedPhoneNumber = "$dialCode$phoneNumber";
    printd("전화번호: $codedPhoneNumber");

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: codedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        printd("인증 성공");
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          updateAuthStatus(AuthStatus.failedInvalidPhoneNumber);
          return;
        }
        printd('인증 실패: ${e.message}');
        updateAuthStatus(AuthStatus.failedAuthCodeNotSent);
      },
      codeSent: (String verificationId, int? resendToken) {
        printd('인증번호 전송됨');
        updateVerificationId(verificationId);
        updateResendToken(resendToken);
        updateAuthCodeSent(true);
        focusNodeChange();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        printd('인증번호 입력 시간 초과');
        updateAuthStatus(AuthStatus.failedAuthCodeTimeout);
      },
      forceResendingToken: getAuthModel.resendToken,
    );
  }

  /// ### 인증번호 확인 메서드
  ///
  /// 사용자가 입력한 인증번호와 verificationId를 통해 인증을 확인한다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] context
  ///
  /// #### Returns
  ///
  /// [bool] 인증 성공 여부
  ///
  Future<bool> verifyAuthCode(BuildContext context) async {
    final String authCode = getAuthModel.authCode ?? "";
    printd("verifyAuthCode: $authCode");
    if (authCode.isEmpty) {
      printd("인증번호 입력 필요");
      updateAuthStatus(AuthStatus.failedAuthCodeEmpty);
      return false;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: getAuthModel.verificationId ?? "",
        smsCode: authCode,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      printd("인증 성공: ${result.user?.uid}");
      printd("인증 성공: ${result.user?.phoneNumber}");
      updateUserUid(result.user?.uid ?? "");

      final userExistStatus = await checkUserExist();

      updateExistStatus(userExistStatus);
      printd("사용자 존재 여부: $userExistStatus");

      if (userExistStatus == UserExistStatus.exist) {
        return true;
      } else {
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              UserExistStatus.notExist.toMessage, context);
        }
        return false;
      }
    } catch (e) {
      printd("인증 실패: $e");
      updateAuthStatus(AuthStatus.failedAuthCodeInvalid);
      return false;
    }
  }

  /// ### 사용자 중복 확인 메서드
  ///
  /// 사용자의 uid를 통해 사용자가 존재하는지 확인한다.
  ///
  /// #### Returns
  ///
  /// [UserExistStatus] 사용자 존재 여부
  ///
  Future<UserExistStatus?> checkUserExist() async {
    final String userUid = getAuthModel.userUid ?? "";
    if (userUid.isEmpty) {
      return null;
    }

    // 사용자 존재 확인
    final result = await UserService.isUserExist(userUid);

    return result;
  }
}

/// ### AuthCallback
///
/// - AuthStateNotifier를 활용하는 콜백 메서드를 정의하는 Extension
///
/// #### Methods
///
/// - [onClickAuthStatusResetButton]: 인증번호 전송 상태 초기화 버튼 클릭 시 호출되는 콜백 메서드
/// - [onClickAuthSendButton]: 인증번호 발송 버튼 클릭 시 호출되는 콜백 메서드
/// - [onClickAuthResendButton]: 인증번호 재전송 버튼 클릭 시 호출되는 콜백 메서드
/// - [onClickAuthConfirmButton]: 인증번호 확인 버튼 클릭 시 호출되는 콜백 메서드
///
extension AuthCallback on AuthStateNotififer {
  /// ### 전화번호 변경 버튼 클릭 시 호출되는 콜백 메서드
  ///
  /// - 인증번호 전송 상태를 초기화한다.
  ///
  /// #### Parameters
  ///
  /// - [Function phoneNumberReset] 전화번호 초기화 함수]
  /// - [Function focusNode] 포커스 노드 초기화 함수
  ///
  /// #### Returns
  ///
  /// [VoidCallback?] 인증번호 전송 상태 초기화 함수
  ///
  VoidCallback? onClickAuthStatusResetButton(
      VoidCallback phoneNumberReset, VoidCallback focusNodeChange) {
    if (getAuthModel.authCodeSent) {
      return () {
        phoneNumberReset();
        updateAuthCodeSent(false);
        focusNodeChange();
      };
    }
    return null;
  }

  /// ### 인증번호 발송 버튼 클릭 시 호출되는 콜백 메서드
  ///
  /// - 입력받은 전화번호로 인증번호를 발송한다.
  ///
  /// #### Parameters
  ///
  /// - [String phoneNumber] 전화번호
  /// - [String dialCode] 국가 코드
  /// - [Function focusNodeChange] 포커스 노드 변경 함수
  ///
  /// #### Returns
  ///
  /// [VoidCallback?] 인증번호 발송 함수
  ///
  VoidCallback? onClickAuthSendButton(
      String phoneNumber, String dialCode, VoidCallback focusNodeChange) {
    if (!getAuthModel.authCodeSent) {
      return () {
        verifyPhoneNumber(phoneNumber, dialCode, focusNodeChange);
      };
    }
    return null;
  }

  /// ### 인증번호 재전송 버튼 클릭 시 호출되는 콜백 메서드
  ///
  /// - 인증번호 재전송을 요청한다.
  ///
  /// #### Parameters
  ///
  /// - [String phoneNumber] 전화번호
  /// - [String dialCode] 국가 코드
  /// - [Function focusNodeChange] 포커스 노드 변경 함수
  ///
  /// #### Returns
  ///
  /// [VoidCallback?] 인증번호 재전송 함수
  ///
  VoidCallback? onClickAuthResendButton(
      String phoneNumber, String dialCode, VoidCallback focusNodeChange) {
    if (getAuthModel.authCodeSent) {
      return () {
        updateAuthCodeSent(false);
        verifyPhoneNumber(phoneNumber, dialCode, focusNodeChange);
      };
    }
    return null;
  }

  /// ### 인증번호 확인 버튼 클릭 시 호출되는 콜백 메서드
  ///
  /// - 입력받은 인증번호를 확인한다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext context] context
  /// - [Function focusNodeChange] 포커스 노드 변경 함수
  ///
  /// #### Returns
  ///
  /// - [VoidCallback?] 인증번호 확인 함수
  ///
  VoidCallback? onClickAuthConfirmButton(
      BuildContext context, VoidCallback focusNodeChange) {
    if (getAuthModel.authCode == null || getAuthModel.authCode!.isEmpty) {
      printd("authConfirmButton: authCode is empty");
      return null;
    }
    if (getAuthModel.authCodeSent && getAuthModel.isValid) {
      printd("authConfirmButton: Function Activated");
      return () async {
        printd("authConfirmButton: ${getAuthModel.authCode}");
        final result = await verifyAuthCode(context);
        if (result) {
          updateAuthCompleted(true);
          focusNodeChange();
        }
        printd("authConfirmButton: $result");
      };
    } else {
      return null;
    }
  }
}
