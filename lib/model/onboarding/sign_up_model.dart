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
  userIDEmpty,
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
      case SignUpError.userIDEmpty:
        return "onboarding.signUp.error.userIDEmpty";
    }
  }
}

class SignUpModel {
  final String phoneNumber;
  final String isoCode;
  final String dialCode;
  final String userID;
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

  SignUpModel({
    required this.phoneNumber,
    required this.isoCode,
    required this.dialCode,
    this.userID = "",
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
  });

  SignUpModel copyWith({
    String? phoneNumber,
    String? isoCode,
    String? dialCode,
    String? userID,
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
  }) {
    return SignUpModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoCode: isoCode ?? this.isoCode,
      dialCode: dialCode ?? this.dialCode,
      userID: userID ?? this.userID,
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
