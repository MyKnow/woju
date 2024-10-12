import 'package:woju/model/user/user_password_model.dart';

/// ### UserPasswordChangeModel
///
/// - 비밀번호 변경 페이지에서 사용하는 모델
///
/// #### Fields
///
/// - [currentPassword]: 현재 비밀번호
/// - [newPassword]: 새로운 비밀번호
/// - [isLoading]: 로딩 상태
///
/// #### Methods
///
/// - [copyWith]: 객체 복사
/// - [initial]: 초기 객체 생성
/// - [currentPasswordFieldKey]: 현재 비밀번호 필드 키
/// - [newPasswordFieldKey]: 새로운 비밀번호 필드 키
///
class UserPasswordChangeModel {
  final UserPasswordModel currentPassword;
  final UserPasswordModel newPassword;
  final bool isLoading;

  UserPasswordChangeModel({
    required this.currentPassword,
    required this.newPassword,
    required this.isLoading,
  });

  UserPasswordChangeModel copyWith({
    UserPasswordModel? currentPassword,
    UserPasswordModel? newPassword,
    bool? isLoading,
  }) {
    return UserPasswordChangeModel(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  static UserPasswordChangeModel initial() {
    return UserPasswordChangeModel(
      currentPassword: UserPasswordModel.initial(),
      newPassword: UserPasswordModel.initial(),
      isLoading: false,
    );
  }

  String get currentPasswordFieldKey => "user_profile_password_current";
  String get newPasswordFieldKey => "user_profile_password_new";
}
