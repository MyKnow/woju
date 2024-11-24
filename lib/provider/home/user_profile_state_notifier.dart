import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_profile_edit_model.dart';

import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';

import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

/// ### 유저 프로필 수정 상태 Notifier
/// - 유저 프로필 수정 상태를 관리하는 StateNotifier
/// - 유저 프로필 수정 상태를 변경하는 액션을 정의
///
final userProfileStateNotifierProvider = StateNotifierProvider.autoDispose<
    UserProfileStateNotifier, UserProfileEditState>((ref) {
  return UserProfileStateNotifier(ref);
});

/// ### UserProfileStateNotifier
///
/// #### Fields
///
/// - [state]: 유저 프로필 수정 모델 상태
/// - [ref]: Riverpod Ref
///
/// #### Methods
///
/// - [readFromDB]: DB에서 유저 프로필 정보 읽기
/// - [updateUserImage]: 유저 프로필 이미지 업데이트
/// - [updateUserNicknameModel]: 유저 닉네임 모델 업데이트
/// - [updateUserNicknameController]: 유저 닉네임 컨트롤러 업데이트
/// - [updateUserGenderModel]: 유저 성별 모델 업데이트
/// - [updateUserBirthDate]: 유저 생년월일 업데이트
/// - [updateIsEditing]: 유저 프로필 수정 상태 업데이트
/// - [backupUserProfile]: 유저 프로필 정보 백업
/// - [clearBackupUserProfile]: 백업된 유저 프로필 정보 삭제
/// - [rollbackUserProfile]: 백업된 유저 프로필 정보 복구
/// - [updateIsLoading]: 로딩 상태 업데이트
/// - [getGenderList]: 성별 리스트 반환
/// - [getUserProfileEditState]: 유저 프로필 수정 모델 반환
///
class UserProfileStateNotifier extends StateNotifier<UserProfileEditState> {
  late Ref ref;
  UserProfileStateNotifier(this.ref) : super(UserProfileEditState.initial()) {
    readFromDB();
  }

  /// ### DB에서 유저 프로필 정보 읽기
  ///
  /// #### Notes
  ///
  /// - DB에서 유저 프로필 정보를 읽어와 상태 변경
  /// - notifier 생성 시 호출
  ///
  void readFromDB() async {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData != null) {
      printd('UserProfileStateNotifier readFromDB: $userData');

      updateUserImage(userData.profileImage);
      updateUserNicknameModel(userData.userNickName, false);
      updateUserNicknameController(userData.userNickName);
      updateUserGenderModel(userData.userGender);
      updateUserBirthDate(userData.userBirthDate);
    }
  }

  void updateUserImage(Uint8List? userImage) {
    if (userImage == null) {
      state = state.copyWith(userImage: null, userImageClear: true);
    } else {
      state = state.copyWith(userImage: userImage, userImageClear: false);
    }
  }

  void updateUserNicknameModel(String? userNickName, bool? isEditing) {
    final userNicknameModel = state.userNicknameModel;

    state = state.copyWith(
      userNicknameModel: userNicknameModel.copyWith(
          nickname: userNickName, isEditing: isEditing),
    );
  }

  void updateUserNicknameController(String userNickName) {
    state.userNicknameController.text = userNickName;
  }

  void updateUserGenderModel(Gender userGender) {
    state = state.copyWith(userGender: userGender);
  }

  void updateUserBirthDate(DateTime userBirthDate) {
    state = state.copyWith(userBirthDate: userBirthDate);
  }

  void updateIsEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }

  /// ### 유저 프로필 정보 백업
  ///
  /// #### Notes
  ///
  /// - 현재 유저 프로필 정보를 백업
  ///
  void backupUserProfile() {
    state = state.copyWith(
      userImageBackup: state.userImage,
      userNicknameBackup: state.userNicknameModel.nickname,
      userGenderBackup: state.userGender,
      userBirthDateBackup: state.userBirthDate,
    );
  }

  /// ### 백업된 유저 프로필 정보 삭제
  void clearBackupUserProfile() {
    state = state.copyWith(isBackupClear: true);
  }

  /// ### 백업된 유저 프로필 정보 복구
  void rollbackUserProfile() {
    updateUserImage(state.userImageBackup);
    updateUserNicknameModel(state.userNicknameBackup, false);
    updateUserGenderModel(state.userGenderBackup!);
    updateUserBirthDate(state.userBirthDateBackup!);
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  UserProfileEditState get getUserProfileEditState => state;
}

/// ### UserProfileEditAction
///
/// - UserProfileStateNotifier를 활용하는 액션을 정의하는 Extensionon
///
/// #### Methods
///
/// - [onChangeUserNickname]: 유저 닉네임 변경 onChage 이벤트
/// - [onClickUserProfileEditButton]: 프로필 수정 버튼 클릭 이벤트
/// - [onClickUserProfileEditCancelButton]: 프로필 수정 취소 버튼 클릭 이벤트
/// - [onClickUserProfileEditCompletButton]: 프로필 수정 완료 버튼 클릭 이벤트
/// - [onClickUserProfileImage]: 프로필 이미지 클릭 이벤트
/// - [onChangeUserGender]: 성별 변경 이벤트
/// - [onChangeUserBirthDate]: 생년월일 변경 이벤트
/// - [onClickLogoutButton]: 로그아웃 버튼 클릭 이벤트
///
extension UserProfileEditAction on UserProfileStateNotifier {
  /// ### 유저 닉네임 변경 onChage 이벤트
  ///
  /// #### Notes
  ///
  /// - 유저 닉네임 변경 시 호출
  ///
  /// #### Parameters
  ///
  /// - `String value`: 변경된 닉네임
  ///
  void onChangeUserNickname(String value) {
    updateUserNicknameModel(value, true);
    updateUserNicknameController(value);
  }

  /// ### 프로필 수정 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - 프로필 수정 버튼 클릭 시 호출
  /// - isEditing 상태를 true로 변경
  /// - 현재 프로필 정보를 백업
  ///
  void onClickUserProfileEditButton() {
    backupUserProfile();
    updateIsEditing(true);
  }

  /// ### 프로필 변경 취소 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - 프로필 변경 취소 버튼 클릭 시 호출
  /// - isEditing 상태를 false로 변경
  /// - 백업된 프로필 정보로 복구
  ///
  void onClickUserProfileEditCancelButton() {
    rollbackUserProfile();
    updateIsEditing(false);
  }

  /// ### 프로필 변경 완료 버튼 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - 프로필 변경 완료 버튼 클릭 시 호출
  /// - 변경된 프로필 정보를 서버로 전송
  /// - 변경된 프로필 정보를 DB에 저장
  /// - 변경 성공 시 isEditing 상태를 false로 변경
  /// - 변경 실패 시 백업된 프로필 정보로 복구
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  /// #### Returns
  ///
  /// - [VoidCallback?] : 닉네임이 유효하지 않을 경우 null 반환, 그 외에는 콜백 함수 반환
  ///
  VoidCallback? onClickUserProfileEditCompletButton(BuildContext context) {
    if (!getUserProfileEditState.userNicknameModel.isNicknameValid) {
      return null;
    }

    return () async {
      // 버튼을 누른 직후, 변경을 하지 못하도록 isEditing 상태를 false로 변경하고 loading 상태를 true로 변경
      updateIsEditing(false);
      updateIsLoading(true);

      final userData = ref.read(userDetailInfoStateProvider);
      final userPassword =
          await SecureStorageService.readSecureData(SecureModel.userPassword);

      if (userData == null || userPassword == null) {
        printd("UserDetailInfoModel or userPassword is null");
        return;
      }

      final updatedUserData = userData.copyWith(
        profileImage: getUserProfileEditState.userImage,
        userNickName: getUserProfileEditState.userNicknameModel.nickname,
        userGender: getUserProfileEditState.userGender,
        userBirthDate: getUserProfileEditState.userBirthDate,
      );

      await ref
          .read(userDetailInfoStateProvider.notifier)
          .update(updatedUserData);

      final result =
          await UserService.updateUser(updatedUserData, userPassword);

      updateIsLoading(false);
      if (result) {
        printd("UserProfile update success");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateSuccess", context);
          updateIsEditing(false);
          clearBackupUserProfile();
        }
      } else {
        printd("UserProfile update failed : $result");
        // 변경 실패 시 다시 isEditing 상태를 true로 변경하고 loading 상태를 false로 변경
        updateIsEditing(true);
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateFailed", context);
        }
      }
    };
  }

  /// ### 프로필 이미지 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - isEditing 상태가 true일 때만 호출 가능
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  /// - `bool? isGallery`: 갤러리에서 이미지 선택 여부
  ///
  Future<void> onClickUserProfileImage(
      BuildContext context, bool? isGallery) async {
    Navigator.pop(context);

    if (isGallery == null) {
      printd("isGallery is null");
      updateUserImage(null);
      return;
    } else {
      final Uint8List? image = isGallery
          ? await ImagePickerService().pickImageForGalleryWithUint8List()
          : await ImagePickerService().pickImageForCameraWithUint8List();

      if (image != null) {
        updateUserImage(image);
      } else {
        printd("Image is null");
        updateUserImage(null);
      }
    }
  }

  /// ### 성별 변경 이벤트
  ///
  /// #### Notes
  ///
  /// - 성별 변경 시 호출
  ///
  /// #### Parameters
  ///
  /// - `int? index`: 변경된 성별 인덱스
  ///
  void onChangeUserGender(int? index) {
    if (index == null) {
      return;
    }
    printd("onChangeUserGender: $index");
    updateUserGenderModel(Gender.values[index]);
  }

  /// ### 생년월일 변경 이벤트
  ///
  /// #### Notes
  ///
  /// - 생년월일 변경 시 호출
  ///
  /// #### Parameters
  ///
  /// - `DateTime? date`: 변경된 생년월일
  ///
  void onChangeUserBirthDate(DateTime? date) {
    if (date == null) {
      return;
    }
    printd("onChangeUserBirthDate: $date");
    updateUserBirthDate(date);
  }

  /// ### 로그아웃 버튼 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - 로그아웃 버튼 클릭 시 호출
  ///
  void onClickLogoutButton() async {
    // 자동 로그인을 위한 SecureStorage 데이터 삭제
    await SecureStorageService.deleteSecureData(SecureModel.userPassword);

    // UserDetailInfoModel 업데이트
    await ref.read(userDetailInfoStateProvider.notifier).delete();

    // 로그인 상태 업데이트
    ref.read(appStateProvider.notifier).updateSignInStatus(SignInStatus.logout);
  }
}

/// ### UserProfileEditNavigationAction
///
/// - 다른 페이지로 이동하는 Action을 정의하는 Extension
///
/// #### Methods
///
/// - [navigateToChangePasswordPage]: 비밀번호 변경 페이지로 이동
/// - [navigateToChangePhoneNumberPage]: 전화번호 변경 페이지로 이동
/// - [navigateToChangeIdPage]: 아이디 변경 페이지로 이동
/// - [navigateToWithdrawalPage]: 회원 탈퇴 페이지로 이동
///
extension UserProfileEditNavigationAction on UserProfileStateNotifier {
  /// ### 비밀번호 변경 페이지로 이동
  ///
  /// #### Notes
  ///
  /// - 비밀번호 변경 페이지로 이동
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  void navigateToChangePasswordPage(BuildContext context) {
    context.push('/userProfile/userPasswordChange');
  }

  /// ### 전화번호 변경 페이지로 이동
  ///
  /// #### Notes
  ///
  /// - 전화번호 변경 페이지로 이동
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  void navigateToChangePhoneNumberPage(BuildContext context) {
    context.push('/userProfile/userPhoneNumberChange');
  }

  /// ### 아이디 변경 페이지로 이동
  ///
  /// #### Notes
  ///
  /// - 아이디 변경 페이지로 이동
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  void navigateToChangeIdPage(BuildContext context) {
    context.push('/userProfile/userIDChange');
  }

  /// ### 회원 탈퇴 페이지로 이동
  ///
  /// #### Notes
  ///
  /// - 회원 탈퇴 페이지로 이동
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  void navigateToWithdrawalPage(BuildContext context) {
    context.push('/userProfile/userWithdrawal');
  }
}
