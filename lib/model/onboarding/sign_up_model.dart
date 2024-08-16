import 'package:image_picker/image_picker.dart';

enum SignUpError {
  phoneNumberEmpty,
  phoneNumberInvalid,
  isoCodeEmpty,
  authCodeEmpty,
  authCodeInvalid,
  authCodeTimeout,
  authCodeNotSent,
  serverError,
  alreadySignedUp,
  userIDNotAvailable,
  userIDShort,
  userIDLong,
  userIDAlphabetFirst,
  userIDInvalid,
  userIDInvalidAlphabet,
  userIDEmpty,
  passwordEmpty,
  passwordShort,
  passwordLong,
  passwordInvalid,
}

extension SignUpErrorExtenstion on SignUpError {
  String get message {
    switch (this) {
      case SignUpError.phoneNumberEmpty:
        return "onboarding.signUp.error.phoneNumberEmpty";
      case SignUpError.phoneNumberInvalid:
        return "onboarding.signUp.error.phoneNumberInvalid";
      case SignUpError.isoCodeEmpty:
        return "onboarding.signUp.error.isoCodeEmpty";
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
      case SignUpError.userIDNotAvailable:
        return "onboarding.signUp.error.userIDNotAvailable";
      case SignUpError.userIDShort:
        return "onboarding.signUp.error.userIDShort";
      case SignUpError.userIDLong:
        return "onboarding.signUp.error.userIDLong";
      case SignUpError.userIDAlphabetFirst:
        return "onboarding.signUp.error.userIDAlphabetFirst";
      case SignUpError.userIDInvalid:
        return "onboarding.signUp.error.userIDInvalid";
      case SignUpError.userIDInvalidAlphabet:
        return "onboarding.signUp.error.userIDInvalidAlphabet";
      case SignUpError.userIDEmpty:
        return "onboarding.signUp.error.userIDEmpty";
      case SignUpError.passwordEmpty:
        return "onboarding.signUp.error.passwordEmpty";
      case SignUpError.passwordShort:
        return "onboarding.signUp.error.passwordShort";
      case SignUpError.passwordLong:
        return "onboarding.signUp.error.passwordLong";
      case SignUpError.passwordInvalid:
        return "onboarding.signUp.error.passwordInvalid";
    }
  }
}

class SignUpModel {
  final String phoneNumber;
  final String isoCode;
  final String dialCode;
  final String userID;
  final String password;
  final XFile? profileImage;
  final String userNickName;
  final bool? gender;
  final String? authCode;
  final SignUpError? error;
  final String? verificationId;
  final String? userUid;
  final int? resendToken;
  final bool authCodeSent;
  final bool isPhoneNumberValid;
  final bool authCompleted;
  final bool isIDValid;
  final bool isIDAvailable;
  final bool isPasswordAvailable;
  final bool isPasswordVisible;
  final bool isUserNickNameValid;

  SignUpModel({
    required this.phoneNumber,
    required this.isoCode,
    required this.dialCode,
    this.userID = "",
    this.password = "",
    this.userNickName = "",
    this.profileImage,
    this.gender,
    this.authCode,
    this.error,
    this.verificationId,
    this.userUid,
    this.resendToken,
    this.authCodeSent = false,
    this.isPhoneNumberValid = false,
    this.authCompleted = false,
    this.isIDValid = false,
    this.isIDAvailable = false,
    this.isPasswordAvailable = false,
    this.isPasswordVisible = false,
    this.isUserNickNameValid = false,
  });

  SignUpModel copyWith({
    String? phoneNumber,
    String? isoCode,
    String? dialCode,
    String? userID,
    String? password,
    XFile? profileImage,
    String? userNickName,
    bool? gender,
    String? authCode,
    SignUpError? error,
    String? verificationId,
    String? userUid,
    int? resendToken,
    bool? authCodeSent,
    bool? isPhoneNumberValid,
    bool? authCompleted,
    bool? isIDValid,
    bool? isIDAvailable,
    bool? isPasswordAvailable,
    bool? isPasswordVisible,
    bool? isUserNickNameValid,
    bool? isProfileImageSetToDefault,
  }) {
    return SignUpModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoCode: isoCode ?? this.isoCode,
      dialCode: dialCode ?? this.dialCode,
      userID: userID ?? this.userID,
      password: password ?? this.password,
      profileImage:
          (isProfileImageSetToDefault != null && isProfileImageSetToDefault)
              ? null
              : profileImage ?? this.profileImage,
      userNickName: userNickName ?? this.userNickName,
      gender: gender ?? this.gender,
      authCode: authCode ?? this.authCode,
      error: error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
      userUid: userUid ?? this.userUid,
      resendToken: resendToken ?? this.resendToken,
      authCodeSent: authCodeSent ?? this.authCodeSent,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      authCompleted: authCompleted ?? this.authCompleted,
      isIDValid: isIDValid ?? this.isIDValid,
      isIDAvailable: isIDAvailable ?? this.isIDAvailable,
      isPasswordAvailable: isPasswordAvailable ?? this.isPasswordAvailable,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isUserNickNameValid: isUserNickNameValid ?? this.isUserNickNameValid,
    );
  }

  factory SignUpModel.initial() {
    return SignUpModel(
      phoneNumber: "",
      isoCode: "KR",
      dialCode: "+82",
    );
  }
}
