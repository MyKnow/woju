import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_auth_model.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotififer, UserAuthModel>(
  (ref) => AuthStateNotififer(ref),
);

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

  void updateResendToken(int resendToken) {
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

  UserAuthModel get getAuthModel => super.state;
}

extension AuthAction on AuthStateNotififer {
  /// ### 전화번호로 인증번호를 전송하는 메서드
  ///
  /// - State에서 [getPhoneNumberWithFormat]을 통해 전화번호를 가져와 인증번호를 전송한다.
  ///
  /// #### Parameters
  ///
  /// - [String phoneNumber] : 전화번호
  /// - [String dialCode] : 국가 코드
  ///
  Future<void> verifyPhoneNumber(String phoneNumber, String dialCode) async {
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
        updateResendToken(resendToken!);
        updateAuthCodeSent(true);
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
  /// [String] authCode: 인증번호
  ///
  /// #### Returns
  ///
  /// [bool] 인증 성공 여부
  ///
  Future<bool> verifyAuthCode() async {
    final String authCode = getAuthModel.authCode ?? "";
    printd("verifyAuthCode: $authCode");
    if (authCode.isEmpty) {
      printd("인증번호 입력 필요");
      updateAuthStatus(AuthStatus.failedAUthCodeEmpty);
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

      if (userExistStatus == UserExistStatus.exist) {
        return true;
      } else {
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
    final result = UserService.isUserExist(userUid);

    return result;
  }
}
