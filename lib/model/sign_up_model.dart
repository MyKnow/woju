import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpModel {
  final PhoneNumber phoneNumber;
  final String? authCode;
  final bool authCodeSent;

  SignUpModel({
    required this.phoneNumber,
    required this.authCode,
    this.authCodeSent = false,
  });

  SignUpModel copyWith({
    PhoneNumber? phoneNumber,
    String? authCode,
    bool? authCodeSent,
  }) {
    return SignUpModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      authCode: authCode ?? this.authCode,
      authCodeSent: authCodeSent ?? this.authCodeSent,
    );
  }

  factory SignUpModel.initial() {
    return SignUpModel(
      phoneNumber: PhoneNumber(isoCode: 'KR'),
      authCode: null,
    );
  }
}
