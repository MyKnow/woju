import 'package:image_picker/image_picker.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';

enum SignUpError {
  authCodeEmpty,
  authCodeInvalid,
  authCodeTimeout,
  authCodeNotSent,
  serverError,
  alreadySignedUp,
  signUpFailure,
}

extension SignUpErrorExtenstion on SignUpError {
  String get toMessage {
    switch (this) {
      case SignUpError.authCodeEmpty:
        return "onboarding.signUp.error.authCodeEmpty";
      case SignUpError.authCodeInvalid:
        return "onboarding.signUp.error.authCodeInvalid";
      case SignUpError.authCodeTimeout:
        return "onboarding.signUp.error.authCodeTimeout";
      case SignUpError.authCodeNotSent:
        return "onboarding.signUp.error.authCodeNotSent";
      case SignUpError.serverError:
        return "onboarding.signUp.error.serverError";
      case SignUpError.alreadySignedUp:
        return "onboarding.signUp.error.alreadySignedUp";
      case SignUpError.signUpFailure:
        return "onboarding.signUp.error.signUpFailure";
    }
  }
}

class SignUpModel {
  final UserPhoneModel userPhoneModel;
  final UserPasswordModel userPasswordModel;
  final UserIDModel userIDModel;
  final UserNicknameModel userNickNameModel;
  final String? userUid;
  final XFile? profileImage;
  final Gender gender;
  final DateTime birthDate;
  final String? authCode;
  final String? error;
  final String? verificationId;
  final int? resendToken;
  final bool authCodeSent;
  final bool authCompleted;

  SignUpModel({
    required this.userPhoneModel,
    required this.userPasswordModel,
    required this.userIDModel,
    required this.userNickNameModel,
    required this.birthDate,
    this.profileImage,
    this.gender = Gender.private,
    this.authCode,
    this.error,
    this.verificationId,
    this.userUid,
    this.resendToken,
    this.authCodeSent = false,
    this.authCompleted = false,
  });

  SignUpModel copyWith({
    String? phoneNumber,
    String? dialCode,
    String? isoCode,
    bool? isPhoneNumberAvailable,
    bool? isPhoneNumberAvailableSetToDefault,
    int? resendToken,
    bool? authCodeSent,
    bool? authCompleted,
    String? verificationId,
    String? userUid,
    String? authCode,
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
      profileImage:
          (isProfileImageSetToDefault != null && isProfileImageSetToDefault)
              ? null
              : profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      authCode: authCode ?? this.authCode,
      error: error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
      userUid: userUid ?? this.userUid,
      resendToken: resendToken ?? this.resendToken,
      authCodeSent: authCodeSent ?? this.authCodeSent,
      authCompleted: authCompleted ?? this.authCompleted,
    );
  }

  factory SignUpModel.initial() {
    return SignUpModel(
      userPhoneModel: UserPhoneModel.initial(),
      userPasswordModel: UserPasswordModel.initial(),
      userIDModel: UserIDModel.initial(),
      userNickNameModel: UserNicknameModel.initial(),
      birthDate: DateTime(2000),
    );
  }
}
