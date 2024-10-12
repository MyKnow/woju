import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

/// ### profileImageStateProvider
///
/// - 유저 프로필 이미지 상태를 관리하는 StateNotifier
///
/// #### Notes
///
/// - autoDispose 속성을 가지므로, 해당 Provider가 더 이상 필요 없을 때 자동으로 해제됨
/// - [ProfileImageStateNotifier] 유저 프로필 이미지 상태를 관리하는 StateNotifier
///
final profileImageStateProvider =
    StateNotifierProvider<ProfileImageStateNotifier, Uint8List?>((ref) {
  return ProfileImageStateNotifier(ref);
});

/// ### ProfileImageStateNotifier
///
/// - 유저 프로필 이미지 상태를 관리하는 StateNotifier
///
/// #### Fields
///
/// - [Uint8List]? state: 유저 프로필 이미지 상태
/// - [Ref] ref: Ref
///
/// #### Methods
///
/// - [void] init(): 유저 프로필 이미지 초기화
/// - [void] update(Uint8List newState): 유저 프로필 이미지 업데이트
/// - [void] delete(): 유저 프로필 이미지 삭제
/// - [Uint8List]? get getImage: 유저 프로필 이미지 반환
///
class ProfileImageStateNotifier extends StateNotifier<Uint8List?> {
  late final Ref ref;
  ProfileImageStateNotifier(this.ref) : super(null) {
    init();
  }

  void init() async {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData == null) {
      return;
    }

    if (userData.profileImage == null) {
      delete();
    } else {
      update(userData.profileImage!);
    }
  }

  void update(Uint8List newState) {
    state = newState;
  }

  void delete() {
    state = null;
  }

  Uint8List? get getImage => state;
}

/// ### ProfileImageAction
///
/// - ProfileImageStateNotifier의 액션 확장
///
/// #### Methods
///
/// - Future<[void]> pickImage([bool]? isGallery, [BuildContext] context): 이미지 선택 메서드
/// - Future<[void]> saveImage(): 이미지를 DB에 저장하는 메서드
/// - Future<[bool]> uploadProfileImage(): 이미지를 서버에 업로드하는 메서드
///
extension ProfileImageAction on ProfileImageStateNotifier {
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
    final backupImage = getImage;

    if (isGallery == null) {
      printd("isGallery is null");
      delete();
    } else {
      final Uint8List? image = isGallery
          ? await ImagePickerService().pickImageForGalleryWithUint8List()
          : await ImagePickerService().pickImageForCameraWithUint8List();

      if (image != null) {
        update(image);
      } else {
        delete();
      }
    }
    await saveImage();
    final result = await uploadProfileImage();

    if (!result) {
      update(backupImage!);
      await saveImage();
      if (context.mounted) {
        // TODO : Dialog로 변경
        Navigator.pop(context);
        ToastMessageService.nativeSnackbar("실패!", context);
      }
    }
  }

  /// ### 이미지를 DB에 저장하는 메서드
  ///
  /// - 이미지를 Hive DB에 저장하는 메서드
  ///
  /// #### Returns
  ///
  /// - [Future<void>] 이미지 저장 메서드
  ///
  Future<void> saveImage() async {
    // Hive DB에 저장된 이미지를 불러옴
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData == null) {
      // 유저 정보가 없으면 return
      return;
    }

    UserDetailInfoModel? newModel;

    // 이미지가 없으면 Hive DB에 있는 이미지를 null로 변경
    if (getImage == null) {
      newModel = userData.copyWith(profileImageDelete: true);
    }
    // 이미지가 있으면 Hive DB에 있는 이미지를 변경
    else {
      newModel = userData.copyWith(profileImage: getImage!);
    }

    // Hive DB에 저장
    await ref.read(userDetailInfoStateProvider.notifier).update(newModel);
  }

  /// ### 서버에 유저 프로필 이미지를 업로드하는 메서드
  ///
  /// - 서버에 유저 프로필 이미지를 업로드하는 메서드
  ///
  /// #### Returns
  ///
  /// - [Future<bool>] 이미지 업로드 성공 여부
  ///
  Future<bool> uploadProfileImage() async {
    final userData = ref.read(userDetailInfoStateProvider);
    final userPassword = await SecureStorageService.readSecureData(
      SecureModel.userPassword,
    );

    if (userData == null || userPassword == null) {
      return false;
    }

    final result = await UserService.updateUser(
      userData,
      userPassword,
    );

    if (result) {
      printd("uploadProfileImage success");
      return true;
    } else {
      printd("uploadProfileImage failed");
      return false;
    }
  }
}
