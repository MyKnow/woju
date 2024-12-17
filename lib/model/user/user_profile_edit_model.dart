import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:woju/model/item/category_model.dart' as woju;
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';

/// # [UserProfileEditState]
/// - 유저 프로필 수정 페이지 상태 모델
///
/// ### Fields
/// - [Uint8List]? - [userImage] : 유저 프로필 이미지
/// - [Uint8List]? - [userImageBackup] : 유저 프로필 이미지 백업
///
/// - [UserNicknameModel] - [userNicknameModel] : 유저 닉네임 모델
/// - [String]? - [userNicknameBackup] : 유저 닉네임 백업
/// - [TextEditingController] - [userNicknameController] : 유저 닉네임 컨트롤러
///
/// - [Gender] - [userGender] : 유저 성별
/// - [Gender]? - [userGenderBackup] : 유저 성별 백업
///
/// - [DateTime] - [userBirthDate] : 유저 생년월일
/// - [DateTime]? - [userBirthDateBackup] : 유저 생년월일 백업
///
/// - [Map]<[woju.Category], [int]> - [userFavoriteCategories] : 유저 관심 카테고리
/// - [Map]<[woju.Category], [int]>? - [userFavoriteCategoriesBackup] : 유저 관심 카테고리 백업
///
/// - [bool] - [isEditing] : 수정 중인지 여부
/// - [bool] - [isLoading] : 로딩 중인지 여부
///
/// ### Methods
/// - [UserProfileEditState] - [copyWith] : 필드를 변경한 새로운 [UserProfileEditState] 생성
/// - [UserProfileEditState] - [initial] : 초기 상태 생성
/// - [String] - [getCategoryString] : 카테고리 문자열 반환
///
///
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

  final Map<woju.Category, int> userFavoriteCategories;
  final Map<woju.Category, int>? userFavoriteCategoriesBackup;

  final bool isEditing;
  final bool isLoading;

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
    required this.userFavoriteCategories,
    this.userFavoriteCategoriesBackup,
    required this.isEditing,
    required this.isLoading,
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
    Map<woju.Category, int>? userFavoriteCategories,
    Map<woju.Category, int>? userFavoriteCategoriesBackup,
    bool? isEditing,
    bool? isBackupClear,
    bool? isLoading,
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
        userFavoriteCategories: this.userFavoriteCategories,
        userFavoriteCategoriesBackup: null,
        isEditing: this.isEditing,
        isLoading: this.isLoading,
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
        userFavoriteCategories:
            userFavoriteCategories ?? this.userFavoriteCategories,
        userFavoriteCategoriesBackup:
            userFavoriteCategoriesBackup ?? this.userFavoriteCategoriesBackup,
        isEditing: isEditing ?? this.isEditing,
        isLoading: isLoading ?? this.isLoading,
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
      userFavoriteCategories: {},
      userFavoriteCategoriesBackup: null,
      isEditing: false,
      isLoading: false,
    );
  }

  /// # [String] - [getCategoryString]
  /// - 카테고리 문자열 반환
  ///
  /// ### Parameters
  /// - None
  ///
  /// ### Return
  /// - [String] : 카테고리 문자열 (LocalizedName)
  ///
  String getCategoryString() {
    if (userFavoriteCategories.isEmpty || userFavoriteCategories.keys.isEmpty) {
      return 'home.userProfile.userFavoriteCategoriesChange.title'.tr();
    }

    // 최대 3개까지만 표시하고, 그 이상일 경우에는 '...' 표시
    if (userFavoriteCategories.keys.length > 3) {
      return '${userFavoriteCategories.keys.take(3).map(
            (e) => e.localizedName.tr(),
          ).join(', ')}...';
    }

    return userFavoriteCategories.keys
        .map(
          (e) => e.localizedName.tr(),
        )
        .join(', ');
  }
}
