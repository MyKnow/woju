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

    final json = await SignInModel.initial().toJson(
      phoneNumber,
      password,
      dialCode,
      isoCode,
      userID,
      password,
    );

    printd("json : $json");

    // 서버로 사용자 정보 전송
    final response = await HttpService.userPost('/user/login', json);

    // 로그인 성공 여부 반환
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final userDetailInfo = UserDetailInfoModel.fromJson(decodedJson);

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
  /// - `Future<String?>` : 비밀번호 변경 성공 여부, 성공했다면 null, 실패했다면 에러 이유를 반환함
  ///
  static Future<String?> changePassword(
      String userID, String oldPassword, String newPassword, Ref ref) async {
    // 새 비밀번호 유효성 검사
    if (UserPasswordModel.isPasswordValid(newPassword) == false) {
      return "error.failureReason.PASSWORD_NOT_MATCH";
    }

    final response = await HttpService.userPost('/user/update-user-password', {
      "userID": userID,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    if (response.statusCode == 200) {
      // SecureStorage에 사용자 비밀번호 저장
      SecureStorageService.writeSecureData(
          SecureModel.userPassword, newPassword);

      // 바뀐 비밀번호로 다시 로그인
      await UserService.autoSignIn(ref);
      return null;
    } else {
      final decode = jsonDecode(response.body);
      final reason = decode['failureReason'] ?? "undefined";
      return reason;
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
    String? userPhoneNumber,
    String? dialCode,
    String? isoCode,
    String? newPassword,
    WidgetRef ref,
  ) async {
    if (userUID == null ||
        newPassword == null ||
        userPhoneNumber == null ||
        dialCode == null ||
        isoCode == null) {
      return false;
    }

    final response = await HttpService.userPost('/user/reset-user-password', {
      "userUID": userUID,
      "userPhoneNumber": userPhoneNumber,
      "dialCode": dialCode,
      "isoCode": isoCode,
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
    final response = await HttpService.userPost('/user/check-user-exists', {
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
    final categoryMapToJson = userDetailInfo.userFavoriteCategoriesMap
        ?.map((key, value) => MapEntry(key.name, value));

    final categoryMapToJsonString = json.encode(categoryMapToJson);
    printd("categoryMapToJsonString: $categoryMapToJsonString");

    final response = await HttpService.userPost(
      '/user/update-user-info',
      {
        "userUUID": userDetailInfo.userUUID,
        "userProfileImage": userDetailInfo.profileImage,
        "userID": userDetailInfo.userID,
        "userPhoneNumber": userDetailInfo.userPhoneNumber,
        "dialCode": userDetailInfo.dialCode,
        "isoCode": userDetailInfo.isoCode,
        "userNickName": userDetailInfo.userNickName,
        "userGender": userDetailInfo.userGender.value,
        "userBirthDate": userDetailInfo.userBirthDate.toString(),
        "userPassword": userPassword,
        "termsVersion": userDetailInfo.termsVersion,
        "privacyVersion": userDetailInfo.privacyVersion,
        "userFavoriteCategories": categoryMapToJsonString,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      printd("response.body: ${response.body}");
      return false;
    }
  }

  /// ### 사용자 ID 업데이트 함수
  ///
  /// #### Notes
  ///
  /// - 사용자 ID를 서버로 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [String] `oldUserID` : 기존 사용자 ID
  /// - [String] `newUserID` : 새로운 사용자 ID
  /// - [String] `userPassword` : 사용자 비밀번호
  ///
  /// #### Returns
  ///
  /// - `Future<bool>` : 업데이트 성공 여부
  ///
  static Future<bool> updateUserID(
    String oldUserID,
    String newUserID,
    String userPassword,
  ) async {
    final response = await HttpService.userPost('/user/update-user-id', {
      "oldUserID": oldUserID,
      "newUserID": newUserID,
      "userPassword": userPassword,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// ### 전화번호 변경 함수
  ///
  /// #### Notes
  ///
  /// - 사용자의 전화번호를 서버로 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [String] `userUUID` : 사용자 UUID
  /// - [String] `userUID` : 사용자 UID
  /// - [String] `userPhoneNumber` : 사용자 전화번호
  /// - [String] `dialCode` : 국가번호
  /// - [String] `isoCode` : 국가코드
  /// - [String] `userPassword` : 사용자 비밀번호
  /// - [WidgetRef] `ref` : Riverpod Ref
  ///
  /// #### Returns
  ///
  /// - `Future<String?>` : 업데이트 성공 여부 (성공: null, 실패: 에러 이유)
  ///
  static Future<String?> updateUserPhoneNumber(
    String userUUID,
    String userUID,
    String userPhoneNumber,
    String dialCode,
    String isoCode,
    String userPassword,
    WidgetRef ref,
  ) async {
    final response =
        await HttpService.userPost('/user/update-user-phonenumber', {
      "userUUID": userUUID,
      "userUID": userUID,
      "userPhoneNumber": userPhoneNumber,
      "dialCode": dialCode,
      "isoCode": isoCode,
      "userPassword": userPassword,
    });

    if (response.statusCode == 200) {
      final userData = ref.watch(userDetailInfoStateProvider);
      if (userData == null) return "USER_DATA_NOT_FOUND";
      await ref.read(userDetailInfoStateProvider.notifier).update(
            userData.copyWith(
              userUID: userUID,
              userPhoneNumber: userPhoneNumber,
              dialCode: dialCode,
              isoCode: isoCode,
            ),
          );

      return null;
    } else {
      final decode = jsonDecode(response.body);
      final reason = decode['failureReason'] ?? "undefined";
      return reason;
    }
  }

  /// ### 사용자 탈퇴 함수
  ///
  /// #### Notes
  ///
  /// - 사용자를 탈퇴 처리합니다.
  ///
  /// #### Parameters
  ///
  /// - [String] `userID` : 사용자 ID
  /// - [String] `userPassword` : 사용자 비밀번호
  /// - [WidgetRef] `ref` : Riverpod Ref
  ///
  /// #### Returns
  ///
  /// - `Future<String?>` : 탈퇴 성공 여부 (성공: null, 실패: 에러 이유)
  ///
  static Future<String?> withdrawal(
      String userID, String userPassword, WidgetRef ref) async {
    final response = await HttpService.userPost('/user/withdraw', {
      "userID": userID,
      "userPassword": userPassword,
    });

    if (response.statusCode == 200) {
      // SecureStorage에 사용자 비밀번호 삭제
      SecureStorageService.deleteSecureData(SecureModel.userPassword);

      // AppState 업데이트
      ref
          .read(appStateProvider.notifier)
          .updateSignInStatus(SignInStatus.logout);

      // UserDetailInfoModel 삭제
      await ref.read(userDetailInfoStateProvider.notifier).delete();

      return null;
    } else {
      final decode = jsonDecode(response.body);
      final reason = decode['failureReason'] ?? "undefined";
      return reason;
    }
  }
}
