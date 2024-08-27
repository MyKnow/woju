import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_auth_model.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/device_info_service.dart';
import 'package:woju/service/secure_storage_service.dart';

class UserService {
  /// ### 로그인 수행 함수
  ///
  /// #### Notes
  ///
  /// - 사용자가 로그인 버튼을 클릭하면 호출됩니다.
  /// - [SignInModel]에 저장된 사용자 정보를 서버로 전송합니다.
  ///
  /// #### Returns
  ///
  /// [Future<SignInStatus>] : 로그인 성공 여부 (loginSuccess: 성공, loginFailedForInvalidLoginInfo: 로그인 정보 오류, loginFailedForServer: 서버 오류)
  ///
  static Future<SignInStatus> login(
    String? phoneNumber,
    String? password,
    String? dialCode,
    String? isoCode,
    String? userID,
    Ref ref,
  ) async {
    if ((phoneNumber == null && userID == null) ||
        password == null ||
        dialCode == null ||
        isoCode == null) return SignInStatus.loginFailedForInvalidLoginInfo;

    // 전화번호의 앞자리가 0이라면 제거
    if ((phoneNumber != null) && phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }
    printd(
        "phoneNumber: $phoneNumber, password: $password, dialCode: $dialCode, isoCode: $isoCode, userID: $userID");
    final json = {
      "userPhoneNumber": phoneNumber,
      "dialCode": dialCode,
      "isoCode": isoCode,
      "userID": userID,
      "userPassword": password,
      "userDeviceID": await DeviceInfoService.getDeviceId(),
    };

    printd("json : $json");

    // 서버로 사용자 정보 전송
    final response = await HttpService.post('/user/login', json);

    // 로그인 성공 여부 반환
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final userDetailInfo =
          UserDetailInfoModel.fromJson(decodedJson['userInfo']);

      printd("profileImage: ${userDetailInfo.profileImage}");

      // UserDetailInfoModel 업데이트
      ref.read(userDetailInfoStateProvider.notifier).update(userDetailInfo);

      // SecureStorage에 사용자 비밀번호 저장
      SecureStorageService.writeSecureData(SecureModel.userPassword, password);
      return SignInStatus.loginSuccess;
    } else if (response.statusCode == 400) {
      return SignInStatus.loginFailedForInvalidLoginInfo;
    } else {
      return SignInStatus.loginFailedForServer;
    }
  }

  /// ### 자동 로그인 수행 함수
  ///
  /// #### Notes
  ///
  /// - 저장된 유저 정보를 바탕으로 자동 로그인을 수행하고, 로그인 상태를 업데이트합니다.
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 자동 로그인 성공 여부
  ///
  static Future<SignInStatus> autoSignIn(Ref ref) async {
    // UserDetailInfoModel을 불러옴
    final userDetailInfo = ref.read(userDetailInfoStateProvider);
    final passwordFromSecureStorage =
        await SecureStorageService.readSecureData(SecureModel.userPassword);

    // UserDetailInfoModel이나 passwordFromSecureStorage가 없다면 AppState를 업데이트
    if (userDetailInfo == null || passwordFromSecureStorage == null) {
      ref
          .read(appStateProvider.notifier)
          .updateSignInStatus(SignInStatus.logout);
      return SignInStatus.logout;
    }

    final result = await UserService.login(
      userDetailInfo.userPhoneNumber,
      passwordFromSecureStorage,
      userDetailInfo.dialCode,
      userDetailInfo.isoCode,
      userDetailInfo.userID,
      ref,
    );

    return result;
  }

  /// ### 비밀번호 변경 함수
  ///
  /// #### Notes
  ///
  /// - 사용자가 비밀번호 변경 버튼을 클릭하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - [String] `userID` : 사용자 ID
  /// - [String] `oldPassword` : 기존 비밀번호
  /// - [String] `newPassword` : 새로운 비밀번호
  /// - [Ref] `ref` : Riverpod Ref
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 비밀번호 변경 성공 여부
  ///
  static Future<bool> changePassword(String userID, String oldPassword,
      String newPassword, WidgetRef ref) async {
    // 새 비밀번호 유효성 검사
    if (UserPasswordModel.isPasswordValid(newPassword) == false) {
      return false;
    }

    final response = await HttpService.post('/user/update-user-password', {
      "userID": userID,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    if (response.statusCode == 200) {
      // SecureStorage에 사용자 비밀번호 저장
      SecureStorageService.writeSecureData(
          SecureModel.userPassword, newPassword);

      // 로그인 상태 업데이트
      ref
          .read(appStateProvider.notifier)
          .updateSignInStatus(SignInStatus.logout);
      return true;
    } else {
      return false;
    }
  }

  /// ### 비밀번호 재설정 함수
  ///
  /// #### Notes
  ///
  /// - 사용자가 비밀번호 재설정 버튼을 클릭하면 호출됩니다.
  ///
  /// #### Parameters
  ///
  /// - [String?] 'userUID' : 사용자 UID
  /// - [String?] 'newPassword' : 새로운 비밀번호
  /// - [Ref] `ref` : Riverpod Ref
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 비밀번호 재설정 성공 여부
  ///
  static Future<bool> resetPassword(
    String? userUID,
    String? newPassword,
    WidgetRef ref,
  ) async {
    if (userUID == null || newPassword == null) {
      return false;
    }

    final response = await HttpService.post('/user/reset-user-password', {
      "userUID": userUID,
      "newPassword": newPassword,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// ### 사용자 가입 여부 확인 함수
  ///
  /// #### Notes
  ///
  /// - 사용자의 가입 여부를 확인합니다.
  ///
  /// #### Parameters
  ///
  /// - [String] `userUID` : 사용자 UID
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 사용자 가입 여부
  ///
  static Future<UserExistStatus> isUserExist(String userUID) async {
    final response = await HttpService.post('/user/check-user-exists', {
      "userUID": userUID,
    });

    if (response.statusCode == 200) {
      return UserExistStatus.exist;
    } else if (response.statusCode == 400) {
      return UserExistStatus.notExist;
    } else {
      return UserExistStatus.error;
    }
  }

  /// ### 유저 정보 업데이트 함수
  ///
  /// #### Notes
  ///
  /// - 사용자 정보를 서버로 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [UserDetailInfoModel] `userDetailInfo` : 사용자 정보
  /// - [String] `userPassword` : 사용자 비밀번호
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 업데이트 성공 여부
  ///
  static Future<bool> updateUser(
      UserDetailInfoModel userDetailInfo, String userPassword) async {
    final response = await HttpService.post('/user/update-user-info', {
      "userProfileImage": userDetailInfo.profileImage,
      "userID": userDetailInfo.userID,
      "userPhoneNumber": userDetailInfo.userPhoneNumber,
      "dialCode": userDetailInfo.dialCode,
      "isoCode": userDetailInfo.isoCode,
      "userNickName": userDetailInfo.userNickName,
      "userGender": userDetailInfo.userGender.value,
      "userBirthDate": userDetailInfo.userBirthDate.toString(),
      "userPassword": userPassword,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
