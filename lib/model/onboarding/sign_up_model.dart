import 'package:image_picker/image_picker.dart';

import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/user/user_auth_model.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';

enum SignUpError with StatusMixin {
  authCodeEmpty,
  authCodeInvalid,
  authCodeTimeout,
  authCodeNotSent,
  serverError,
  alreadySignedUp,
  signUpFailure,
}

class SignUpModel {
  final UserPhoneModel userPhoneModel;
  final UserPasswordModel userPasswordModel;
  final UserIDModel userIDModel;
  final UserNicknameModel userNickNameModel;
  final UserAuthModel userAuthModel;
  final XFile? profileImage;
  final Gender gender;
  final DateTime birthDate;
  final bool termsAgree;
  final bool privacyAgree;
  final String? error;

  SignUpModel({
    required this.userPhoneModel,
    required this.userPasswordModel,
    required this.userIDModel,
    required this.userNickNameModel,
    required this.userAuthModel,
    required this.birthDate,
    this.profileImage,
    this.gender = Gender.private,
    this.termsAgree = false,
    this.privacyAgree = false,
    this.error,
  });

  SignUpModel copyWith({
    String? phoneNumber,
    String? dialCode,
    String? isoCode,
    bool? isPhoneNumberAvailable,
    bool? isPhoneNumberAvailableSetToDefault,
    UserAuthModel? userAuthModel,
    String? password,
    bool? isPasswordAvailable,
    bool? isPasswordVisible,
    String? userID,
    bool? isIDValid,
    bool? isIDAvailable,
    XFile? profileImage,
    bool? isProfileImageSetToDefault,
    String? userNickName,
    Gender? gender,
    DateTime? birthDate,
    String? error,
    bool? termsAgree,
    bool? privacyAgree,
  }) {
    return SignUpModel(
      userPhoneModel: (isPhoneNumberAvailableSetToDefault != null &&
              isPhoneNumberAvailableSetToDefault)
          ? userPhoneModel.resetPhoneNumberAvailable()
          : userPhoneModel.copyWith(
              phoneNumber: phoneNumber,
              dialCode: dialCode,
              isoCode: isoCode,
              isPhoneNumberAvailable: isPhoneNumberAvailable,
            ),
      userPasswordModel: userPasswordModel.copyWith(
        password: password,
        isPasswordVisible: isPasswordVisible,
      ),
      userIDModel: userIDModel.copyWith(
        userID: userID,
        isIDAvailable: isIDAvailable,
      ),
      userNickNameModel: userNickNameModel.copyWith(
        nickname: userNickName,
      ),
      userAuthModel: userAuthModel ?? this.userAuthModel,
      profileImage:
          (isProfileImageSetToDefault != null && isProfileImageSetToDefault)
              ? null
              : profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      error: error ?? this.error,
      termsAgree: termsAgree ?? this.termsAgree,
      privacyAgree: privacyAgree ?? this.privacyAgree,
    );
  }

  factory SignUpModel.initial() {
    return SignUpModel(
      userPhoneModel: UserPhoneModel.initial(),
      userPasswordModel: UserPasswordModel.initial(),
      userIDModel: UserIDModel.initial(),
      userAuthModel: UserAuthModel.initial(),
      userNickNameModel: UserNicknameModel.initial(),
      birthDate: DateTime(2000),
    );
  }
}
