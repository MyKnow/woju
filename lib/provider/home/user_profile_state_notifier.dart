import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/item/category_model.dart' as woju;
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
import 'package:woju/theme/widget/adaptive_dialog.dart';
import 'package:woju/theme/widget/custom_text.dart';

/// ### [UserProfileEditState]
/// - 유저 프로필 수정 상태를 관리하는 StateNotifier
///
final userProfileStateNotifierProvider = StateNotifierProvider.autoDispose<
    UserProfileStateNotifier, UserProfileEditState>((ref) {
  return UserProfileStateNotifier(ref);
});

/// ### [UserProfileStateNotifier]
///
/// #### Fields
///
/// - [state]: 유저 프로필 수정 모델 상태
/// - [ref]: Riverpod Ref
///
/// #### Methods
/// - [void] - [readFromDB] : DB에서 유저 프로필 정보 읽기
/// - [void] - [updateUserImage] :  유저 프로필 이미지 업데이트
/// - [void] - [updateUserNicknameModel] : 유저 닉네임 모델 업데이트
/// - [void] - [updateUserNicknameController] : 유저 닉네임 컨트롤러 업데이트
/// - [void] - [updateUserGenderModel] : 유저 성별 모델 업데이트
/// - [void] - [updateUserBirthDate] : 유저 생년월일 업데이트
/// - [void] - [updateIsEditing] : 유저 프로필 수정 상태 업데이트
/// - [void] - [backupUserProfile] : 유저 프로필 정보 백업
/// - [void] - [clearBackupUserProfile] : 백업된 유저 프로필 정보 삭제
/// - [void] - [rollbackUserProfile] : 백업된 유저 프로필 정보 복구
/// - [void] - [updateIsLoading] : 로딩 상태 업데이트
/// - [UserProfileEditState] - [getUserProfileEditState] : 유저 프로필 수정 모델 반환
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
      updateUserFavoriteCategories(userData.userFavoriteCategoriesMap);
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

  void updateUserFavoriteCategories(Map<woju.Category, int>? userCategory) {
    printd("updateUserFavoriteCategories");
    state = state.copyWith(userFavoriteCategories: userCategory);
    printd("userFavoriteCategories: $userCategory");
    printd(
        "userFavoriteCategoriesBackup: ${state.userFavoriteCategoriesBackup}");
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
      userFavoriteCategoriesBackup: state.userFavoriteCategories,
    );
  }

  /// ### 백업된 유저 프로필 정보 삭제
  void clearBackupUserProfile() {
    printd("clearBackupUserProfile");
    state = state.copyWith(isBackupClear: true);
  }

  /// ### 백업된 유저 프로필 정보 복구
  void rollbackUserProfile() {
    printd("rollbackUserProfile");
    updateUserImage(state.userImageBackup);
    updateUserNicknameModel(state.userNicknameBackup, false);
    if (state.userGenderBackup != null) {
      updateUserGenderModel(state.userGenderBackup!);
    }
    if (state.userBirthDateBackup != null) {
      updateUserBirthDate(state.userBirthDateBackup!);
    }
    if (state.userFavoriteCategoriesBackup != null) {
      updateUserFavoriteCategories(state.userFavoriteCategoriesBackup!);
    }
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  UserProfileEditState get getUserProfileEditState => state;
}

/// ### [UserProfileEditAction]
/// - UserProfileStateNotifier를 활용하는 액션을 정의하는 Extensionon
///
/// #### Methods
/// - [void] - [onChangeUserNickname] : 유저 닉네임 변경 onChage 이벤트
/// - [void] - [onClickUserProfileEditButton] : 프로필 수정 버튼 클릭 이벤트
/// - [void] - [onClickUserProfileEditCancelButton] : 프로필 수정 취소 버튼 클릭 이벤트
/// - [VoidCallback]? - [onClickUserProfileEditCompletButton] : 프로필 수정 완료 버튼 클릭 이벤트
/// - [Future]<[void]> - [onClickUserProfileImage] : 프로필 이미지 클릭 이벤트
/// - [void] - [onChangeUserGender] : 성별 변경 이벤트
/// - [void] - [onChangeUserBirthDate] : 생년월일 변경 이벤트
/// - [void] - [onClickLogoutButton] : 로그아웃 버튼 클릭 이벤트
/// - [Future]<[void]> - [updateCategoryOrder] : 유저의 선호 카테고리를 서버에 업데이트
/// - [void] - [onReorderCategory] : 유저의 선호 카테고리 순서를 변경
/// - [void] - [onTapAddToFavoriteCategory] : 유저의 선호 카테고리에 추가
/// - [bool] - [onDismissedRemoveFromFavoriteCategory] : 유저의 선호 카테고리에서 제거
/// - [void] - [onTapShowDialogOfCategoryInfo] : 카테고리 정보 다이얼로그 표시
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

      printd("UserProfile update result: $result");
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

  /// ### [Future]<[bool]> - [updateCategoryOrder]
  /// - 유저의 선호 카테고리를 서버에 업데이트
  ///
  /// ### Return
  /// - [Future]<[bool]> : 성공 시 true, 실패 시 false 반환
  ///
  Future<bool> updateCategoryOrder() async {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData == null) {
      printd("UserDetailInfoModel is null");
      return false;
    }

    final originalUserInfo = ref.read(userDetailInfoStateProvider);

    if (originalUserInfo == null) {
      printd("UserDetailInfoModel is null");
      return false;
    }

    // userFavoriteCategoriesList 업데이트
    final userDetailInfo = originalUserInfo.copyWith(
        userFavoriteCategoriesList:
            getUserProfileEditState.userFavoriteCategories);

    // 비밀번호 가져오기
    final userPassword =
        await SecureStorageService.readSecureData(SecureModel.userPassword);

    if (userPassword == null) {
      printd("UserPassword is null");
      return false;
    }

    // UserService의 updateUserInfo 호출
    final response = await UserService.updateUser(userDetailInfo, userPassword);

    // 업데이트 성공 시 UserDetailInfoModel 업데이트, 실패 시 로그 출력
    if (response) {
      printd("updateCategoryOrder success");
      await ref
          .read(userDetailInfoStateProvider.notifier)
          .update(userDetailInfo);

      return true;
    } else {
      printd("updateCategoryOrder failed");
      return false;
    }
  }

  /// ### [void] - [onReorderCategory]
  /// - 유저의 선호 카테고리 순서를 변경
  ///
  /// ### Parameters
  /// - [int] - [oldIndex] : 이전 인덱스
  /// - [int] - [newIndex] : 새로운 인덱스
  ///
  /// ### Return
  /// - [void] : 콜백 함수 반환
  ///
  void onReorderCategory(int oldIndex, int newIndex) {
    // 얕은 복사 방지를 위해 Map.from 사용
    final favoriteCategories = Map<woju.Category, int>.from(
        getUserProfileEditState.userFavoriteCategories);

    // 현재 favoriteCategories에서 int 값이 낮은 카테고리를 가장 최상위에 두는 List로 변환
    final sortedFavoriteCategories = favoriteCategories.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // 이전 인덱스와 새로운 인덱스가 같을 경우 return
    if (oldIndex == newIndex) {
      return;
    }

    // 이전 인덱스와 새로운 인덱스가 다를 경우, 이전 인덱스의 카테고리를 새로운 인덱스로 이동
    final category = sortedFavoriteCategories.removeAt(oldIndex);
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    sortedFavoriteCategories.insert(newIndex, category);

    // 새로운 인덱스로 이동한 카테고리를 favoriteCategories에 업데이트
    final newFavoriteCategories = {
      for (var i = 0; i < sortedFavoriteCategories.length; i++)
        sortedFavoriteCategories[i].key: i
    };

    // favoriteCategories 업데이트
    updateUserFavoriteCategories(newFavoriteCategories);
  }

  /// ### [void] - [onTapAddToFavoriteCategory]
  /// - 유저의 선호 카테고리에 추가
  ///
  /// ### Notes
  /// - 유저의 비선호 카테고리에 있던 카테고리를 선호 카테고리로 이동
  ///
  /// ### Parameters
  /// - [woju.Category] - [category] : 카테고리
  ///
  /// ### Return
  /// - [void] : 반환값 없음
  ///
  void onTapAddToFavoriteCategory(woju.Category category) {
    // userFavoriteCategories의 복사본 생성 (얕은 복사를 방지하기 위해 Map.from 사용)
    final favoriteCategories = Map<woju.Category, int>.from(
        getUserProfileEditState.userFavoriteCategories);

    // 모든 카테고리를 가져옴
    final allCategories = woju.Category.values.toList();

    // 비선호 카테고리를 필터링
    final nonFavoriteCategories = allCategories
        .where((category) => !getUserProfileEditState
            .userFavoriteCategories.keys
            .contains(category))
        .toList();

    // 선택한 카테고리가 비선호 카테고리에 있다면 추가
    if (nonFavoriteCategories.contains(category)) {
      favoriteCategories.putIfAbsent(category, () => favoriteCategories.length);

      // 상태 업데이트
      updateUserFavoriteCategories(favoriteCategories);
    } else {
      printd("Category is already in favorite category");
    }
  }

  /// ### [bool] - [onDismissedRemoveFromFavoriteCategory]
  /// - 유저의 선호 카테고리에서 제거
  ///
  /// ### Notes
  /// - 유저의 선호 카테고리에 있던 카테고리를 비선호 카테고리로 이동
  ///
  /// ### Parameters
  /// - [woju.Category] - [category] : 카테고리
  ///
  /// ### Return
  /// - [bool] : 반환값 없음
  ///
  bool onDismissedRemoveFromFavoriteCategory(woju.Category category) {
    // userFavoriteCategories의 복사본 생성 (얕은 복사를 방지하기 위해 Map.from 사용)
    final favoriteCategories = Map<woju.Category, int>.from(
        getUserProfileEditState.userFavoriteCategories);

    if (favoriteCategories.containsKey(category)) {
      // favoriteCategories에서 카테고리 제거
      favoriteCategories.remove(category);

      // favoriteCategories의 순서를 업데이트
      final newFavoriteCategories = {
        for (var i = 0; i < favoriteCategories.length; i++)
          favoriteCategories.keys.elementAt(i): i
      };

      updateUserFavoriteCategories(newFavoriteCategories);

      return true;
    } else {
      printd("Category is not in favorite category");
      return false;
    }
  }

  /// ### [void] - [onTapShowDialogOfCategoryInfo]
  /// - 카테고리 정보 다이얼로그 표시
  ///
  /// ### Parameters
  /// - [BuildContext] - [context] : BuildContext
  /// - [woju.Category] - [category] : 카테고리
  ///
  /// ### Return
  /// - [void] : 반환값 없음
  ///
  void onTapShowDialogOfCategoryInfo(
      BuildContext context, woju.Category category) {
    AdaptiveDialog.showAdaptiveDialog(
      context,
      title: category.localizedName.tr(),
      content: Column(
        children: [
          category.image,
          CustomText(
            category.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
      actions: {
        Text("common.close".tr()): () {
          Navigator.pop(context);
        },
      },
    );
  }

  /// ### [void] - [onPopInvokedWithResultFavoriteCategoryPage]
  /// - 즐겨찾기 카테고리 페이지에서 뒤로가기 시 호출
  ///
  /// #### Notes
  /// - 백업이 존재하고 기존 데이터와 다를 경우, 업데이트가 되지 않은 상태임
  /// - 업데이트 할 것인지 물어보는 다이얼로그 표시
  ///
  /// #### Dialog
  /// - 업데이트 : 변경사항 서버 반영 후 백업 삭제 및 페이지 닫기
  /// - 업데이트 취소 : 변경사항 취소 및 백업 데이터 복구
  /// - 취소 : 창만 닫기
  ///
  /// ### Parameters
  /// - [BuildContext] - [context] : BuildContext
  ///
  /// ### Return
  /// - [Future]<[void]> : 반환값 없음
  ///
  Future<void> onPopInvokedWithResultFavoriteCategoryPage(
      BuildContext context) async {
    printd("onPopInvokedWithResultFavoriteCategoryPage");
    printd(
        "userFavoriteCategories: ${getUserProfileEditState.userFavoriteCategories}");
    printd(
        "userFavoriteCategoriesBackup: ${getUserProfileEditState.userFavoriteCategoriesBackup}");

    // 데이터 변경 여부 확인
    final hasUnsavedChanges = getUserProfileEditState.userFavoriteCategories !=
        getUserProfileEditState.userFavoriteCategoriesBackup;

    if (hasUnsavedChanges) {
      // 다이얼로그를 안전하게 표시
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          AdaptiveDialog.showAdaptiveDialog(
            context,
            title: "home.userProfile.userFavoriteCategoriesChange.title".tr(),
            content: CustomText(
              "home.userProfile.userFavoriteCategoriesChange.content".tr(),
            ),
            actions: {
              Text("home.userProfile.userFavoriteCategoriesChange.update".tr()):
                  () async {
                // 다이얼로그 닫기
                context.pop();

                // 변경사항 서버 반영
                final result = await updateCategoryOrder();

                if (result) {
                  // 백업 데이터 초기화 및 페이지 닫기
                  clearBackupUserProfile();

                  if (context.mounted) {
                    // 백업 데이터 초기화 및 페이지 닫기
                    ToastMessageService.nativeSnackbar(
                        "status.UserServiceStatus.updateSuccess", context);
                    context.pop();
                  }
                } else {
                  // 변경사항 서버 반영 실패: 백업 데이터 복구
                  if (context.mounted) {
                    ToastMessageService.nativeSnackbar(
                        "status.UserServiceStatus.updateFailed", context);
                    rollbackUserProfile();
                  }
                }
              },
              Text(
                "home.userProfile.userFavoriteCategoriesChange.updateCancel"
                    .tr(),
              ): () {
                // 다이얼로그 닫기
                context.pop();

                // 변경사항 취소 및 복구
                rollbackUserProfile();

                // 페이지 닫기
                context.pop();
              },
              Text("common.cancel".tr()): () {
                // 취소: 창만 닫기

                // 다이얼로그 닫기
                context.pop();
              },
            },
          );
        },
      );
    } else {
      // 변경사항 없음: 페이지 닫기
      context.pop();
    }
  }
}

/// ### [UserProfileEditNavigationAction]
/// - 다른 페이지로 이동하는 Action을 정의하는 Extension
///
/// #### Methods
/// - [void] - [navigateToChangePasswordPage] : 비밀번호 변경 페이지로 이동
/// - [void] - [navigateToChangePhoneNumberPage] : 전화번호 변경 페이지로 이동
/// - [void] - [navigateToChangeIdPage] : 아이디 변경 페이지로 이동
/// - [void] - [navigateToWithdrawalPage] : 회원 탈퇴 페이지로 이동
/// - [VoidCallback] - [pushToUserFavoriteCategoriesPage] : 유저 즐겨찾기 카테고리 페이지로 이동
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

  /// ### [VoidCallback] - [pushToUserFavoriteCategoriesPage]
  /// - 유저 즐겨찾기 카테고리 페이지로 이동
  ///
  /// ### Parameters
  /// - [BuildContext] - [context] : BuildContext
  ///
  /// ### Return
  /// - [VoidCallback] : 콜백 함수 반환
  ///
  VoidCallback pushToUserFavoriteCategoriesPage(BuildContext context) {
    return () {
      // 기존 즐겨찾기 데이터 백업
      backupUserProfile();

      // 즐겨찾기 카테고리 페이지로 이동
      context.push('/userProfile/userFavoriteCategoriesChange');
    };
  }
}
