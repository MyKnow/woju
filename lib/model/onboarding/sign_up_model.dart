import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
    }
  }
}

class SignUpModel {
  final String phoneNumber;
  final String isoCode;
  final String dialCode;
  final String? authCode;
  final SignUpError? error;
  final String? verificationId;
  final String? userUid;
  final int? resendToken;
  final bool authCodeSent;
  final bool isPhoneNumberValid;
  final bool authCompleted;

  SignUpModel({
    required this.phoneNumber,
    required this.isoCode,
    required this.dialCode,
    this.authCode,
    this.error,
    this.verificationId,
    this.userUid,
    this.resendToken,
    this.authCodeSent = false,
    this.isPhoneNumberValid = false,
    this.authCompleted = false,
  });

  SignUpModel copyWith({
    String? phoneNumber,
    String? isoCode,
    String? dialCode,
    String? authCode,
    SignUpError? error,
    String? verificationId,
    String? userUid,
    int? resendToken,
    bool? authCodeSent,
    bool? isPhoneNumberValid,
    bool? authCompleted,
  }) {
    return SignUpModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoCode: isoCode ?? this.isoCode,
      dialCode: dialCode ?? this.dialCode,
      authCode: authCode ?? this.authCode,
      error: error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
      userUid: userUid ?? this.userUid,
      resendToken: resendToken ?? this.resendToken,
      authCodeSent: authCodeSent ?? this.authCodeSent,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      authCompleted: authCompleted ?? this.authCompleted,
    );
  }

  factory SignUpModel.initial() {
    return SignUpModel(
      phoneNumber: "",
      isoCode: "KR",
      dialCode: "+82",
    );
  }

  get getPhoneNumberObject => PhoneNumber(
        phoneNumber: phoneNumber,
        isoCode: isoCode,
        dialCode: dialCode,
      );
}
