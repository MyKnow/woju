import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

class UserProfileEditState {
  final Uint8List? userImage;
  final Uint8List? userImageBackup;

  final UserNicknameModel userNicknameModel;
  final String? userNicknameBackup;
  final TextEditingController userNicknameController;

  final Gender userGender;
  final Gender? userGenderBackup;

  final DateTime userBirthDate;
  final DateTime? userBirthDateBackup;

  final bool isEditing;
  final bool isLoding;

  UserProfileEditState({
    required this.userImage,
    this.userImageBackup,
    required this.userNicknameModel,
    this.userNicknameBackup,
    required this.userNicknameController,
    required this.userGender,
    this.userGenderBackup,
    required this.userBirthDate,
    this.userBirthDateBackup,
    required this.isEditing,
    required this.isLoding,
  });

  UserProfileEditState copyWith({
    Uint8List? userImage,
    Uint8List? userImageBackup,
    bool? userImageClear,
    UserNicknameModel? userNicknameModel,
    String? userNicknameBackup,
    TextEditingController? userNicknameController,
    Gender? userGender,
    Gender? userGenderBackup,
    DateTime? userBirthDate,
    DateTime? userBirthDateBackup,
    bool? isEditing,
    bool? isBackupClear,
    bool? isLoding,
  }) {
    if (isBackupClear == true) {
      return UserProfileEditState(
        userImage: this.userImage,
        userNicknameModel: this.userNicknameModel,
        userNicknameController: this.userNicknameController,
        userGender: this.userGender,
        userBirthDate: this.userBirthDate,
        userImageBackup: null,
        userNicknameBackup: null,
        userGenderBackup: null,
        userBirthDateBackup: null,
        isEditing: this.isEditing,
        isLoding: this.isLoding,
      );
    } else {
      return UserProfileEditState(
        userImage: userImageClear == true ? null : userImage ?? this.userImage,
        userImageBackup: userImageBackup ?? this.userImageBackup,
        userNicknameModel: userNicknameModel ?? this.userNicknameModel,
        userNicknameBackup: userNicknameBackup ?? this.userNicknameBackup,
        userNicknameController:
            userNicknameController ?? this.userNicknameController,
        userGender: userGender ?? this.userGender,
        userGenderBackup: userGenderBackup ?? this.userGenderBackup,
        userBirthDate: userBirthDate ?? this.userBirthDate,
        userBirthDateBackup: userBirthDateBackup ?? this.userBirthDateBackup,
        isEditing: isEditing ?? this.isEditing,
        isLoding: isLoding ?? this.isLoding,
      );
    }
  }

  static UserProfileEditState initial() {
    return UserProfileEditState(
      userImage: null,
      userNicknameModel: UserNicknameModel.initial(),
      userNicknameController: TextEditingController(),
      userGender: Gender.private,
      userBirthDate: DateTime.now(),
      isEditing: false,
      isLoding: false,
    );
  }
}

final userProfileStateNotifierProvider = StateNotifierProvider.autoDispose<
    UserProfileStateNotifier, UserProfileEditState>((ref) {
  return UserProfileStateNotifier(ref);
});

class UserProfileStateNotifier extends StateNotifier<UserProfileEditState> {
  late Ref ref;
  UserProfileStateNotifier(this.ref) : super(UserProfileEditState.initial()) {
    readFromDB();
  }

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

  void backupUserProfile() {
    state = state.copyWith(
      userImageBackup: state.userImage,
      userNicknameBackup: state.userNicknameModel.nickname,
      userGenderBackup: state.userGender,
      userBirthDateBackup: state.userBirthDate,
    );
  }

  void clearBackupUserProfile() {
    state = state.copyWith(isBackupClear: true);
  }

  void rollbackUserProfile() {
    updateUserImage(state.userImageBackup);
    updateUserNicknameModel(state.userNicknameBackup, false);
    updateUserGenderModel(state.userGenderBackup!);
    updateUserBirthDate(state.userBirthDateBackup!);
  }

  void updateIsLoding(bool isLoding) {
    state = state.copyWith(isLoding: isLoding);
  }

  List<String> getGenderList() {
    return Gender.values.map((e) => e.toMessage.tr()).toList();
  }

  UserProfileEditState get getUserProfileEditState => state;
}

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
      updateIsLoding(true);

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

      updateIsLoding(false);
      if (result) {
        printd("UserProfile update success");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateSuccess", context);
          updateIsEditing(false);
          clearBackupUserProfile();
        }
      } else {
        printd("UserProfile update failed");
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
}
