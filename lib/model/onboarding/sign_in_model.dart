import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';
import 'package:woju/service/device_info_service.dart';

/// ### 로그인 상태
///
/// 로그인 시도 후 상태를 나타냅니다.
///
/// - [loginFailedForInvalidLoginInfo] : 로그인을 시도했으나 로그인 정보 오류가 발생한 상태
/// - [loginFailedForServer] : 로그인을 시도했으나 서버 오류가 발생한 상태
/// - [withDrawalFailed] : 회원 탈퇴를 시도했으나 서버 오류가 발생한 상태
/// - [loginSuccess] : 로그인을 성공한 상태
/// - [logout] : 로그인을 시도하지 않았거나, 로그아웃을 실행한 상태
///
enum SignInStatus with StatusMixin {
  loginFailedForInvalidLoginInfo,
  loginFailedForServer,
  withDrawalFailed,
  loginSuccess,
  logout,
}

class SignInModel {
  final UserPhoneModel userPhoneModel;
  final UserPasswordModel userPasswordModel;
  final UserIDModel userIDModel;
  final bool loginWithPhoneNumber;

  SignInModel({
    required this.userPhoneModel,
    required this.userPasswordModel,
    required this.userIDModel,
    this.loginWithPhoneNumber = false,
  });

  SignInModel copyWith({
    UserPhoneModel? userPhoneModel,
    UserPasswordModel? userPasswordModel,
    UserIDModel? userIDModel,
    bool? loginWithPhoneNumber,
    SignInStatus? signInStatus,
  }) {
    return SignInModel(
      userPhoneModel: userPhoneModel ?? this.userPhoneModel,
      userPasswordModel: userPasswordModel ?? this.userPasswordModel,
      userIDModel: userIDModel ?? this.userIDModel,
      loginWithPhoneNumber: loginWithPhoneNumber ?? this.loginWithPhoneNumber,
    );
  }

  static SignInModel initial() {
    return SignInModel(
      userPhoneModel: UserPhoneModel.initial(),
      userPasswordModel: UserPasswordModel.initial(),
      userIDModel: UserIDModel.initial(),
      loginWithPhoneNumber: false,
    );
  }

  /// ### toJson
  ///
  /// - 로그인 정보를 JSON 형식으로 변환하는 메서드
  ///
  /// ### Returns
  ///
  /// - [Map<String, dynamic>] JSON 데이터
  ///
  Future<Map<String, dynamic>> toJson(
    String? phoneNumber,
    String? password,
    String? dialCode,
    String? isoCode,
    String? userID,
    String? userPassword,
  ) async {
    final json = {
      "userPhoneNumber": phoneNumber ?? userPhoneModel.phoneNumber,
      "dialCode": dialCode ?? userPhoneModel.dialCode,
      "isoCode": isoCode ?? userPhoneModel.isoCode,
      "userID": userID ?? userIDModel.userID,
      "userPassword": userPassword ?? userPasswordModel.userPassword,
      "userDeviceID": await DeviceInfoService.getDeviceId(),
    };

    return json;
  }
}
