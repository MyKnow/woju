import 'package:easy_localization/easy_localization.dart';
import 'package:woju/service/debug_service.dart';

enum PhoneNumberStatus {
  phoneNumberLengthInvalid,
  phoneNumberInvalid,
  phoneNumberValid,
  phoneNumberNotAvailable,
  countrycodeEmpty,
}

extension PhoneNumberValidErrorExtension on PhoneNumberStatus {
  String? get toMessage {
    switch (this) {
      case PhoneNumberStatus.phoneNumberLengthInvalid:
        return "status.phoneNumber.lengthInvalid";
      case PhoneNumberStatus.phoneNumberInvalid:
        return "status.phoneNumber.invalid";
      case PhoneNumberStatus.phoneNumberValid:
        return null;
      case PhoneNumberStatus.countrycodeEmpty:
        return "status.phoneNumber.countrycodeEmpty";
      case PhoneNumberStatus.phoneNumberNotAvailable:
        return "status.phoneNumber.notAvailable";
      default:
        return null;
    }
  }
}

class UserPhoneModel {
  final String dialCode;
  final String isoCode;
  final String? phoneNumber;
  final bool isPhoneNumberValid;
  final bool? isPhoneNumberAvailable;

  UserPhoneModel({
    required this.dialCode,
    required this.isoCode,
    required this.phoneNumber,
    this.isPhoneNumberAvailable,
  }) : isPhoneNumberValid = phoneNumberValidation(phoneNumber) ==
            PhoneNumberStatus.phoneNumberValid;

  /// ### Model State 변경 메소드
  ///
  /// #### Parameters
  ///
  /// - `dialCode` : 변경할 국가 전화번호 코드
  /// - `isoCode` : 변경할 국가 코드
  /// - `phoneNumber` : 변경할 전화번호
  ///
  /// #### Returns
  ///
  /// 변경된 UserPhoneModel 객체를 반환합니다.
  ///
  /// #### Notes
  ///
  /// - `dialCode`와 `isoCode`는 함께 변경해야 합니다.
  /// - 변경하려는 값이 없는 경우 현재의 값을 그대로 반환합니다.
  ///
  UserPhoneModel copyWith({
    String? dialCode,
    String? isoCode,
    String? phoneNumber,
    bool? isPhoneNumberAvailable,
  }) {
    if (dialCode != null && isoCode != null) {
      return UserPhoneModel(
        dialCode: dialCode,
        isoCode: isoCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
      );
    } else if (phoneNumber != null) {
      return UserPhoneModel(
        dialCode: this.dialCode,
        isoCode: this.isoCode,
        phoneNumber: phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
      );
    } else {
      return UserPhoneModel(
        dialCode: this.dialCode,
        isoCode: this.isoCode,
        phoneNumber: this.phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
      );
    }
  }

  /// ### isPhoneNumberAvailable 초기화 메소드
  ///
  /// #### Returns
  ///
  /// isPhoneNumberAvailable을 null로 초기화한 UserPhoneModel 객체를 반환합니다.
  ///
  UserPhoneModel resetPhoneNumberAvailable() {
    return UserPhoneModel(
      dialCode: dialCode,
      isoCode: isoCode,
      phoneNumber: phoneNumber,
      isPhoneNumberAvailable: null,
    );
  }

  // 전화번호 유효성 검사 메소드
  static PhoneNumberStatus phoneNumberValidation(String? value) {
    if (value == null || value.length < 5 || value.length > 15) {
      return PhoneNumberStatus.phoneNumberLengthInvalid;
    } else if (value.contains(RegExp(r'[^\d]'))) {
      // 숫자가 아닌 다른 문자가 포함되어 있는 경우
      return PhoneNumberStatus.phoneNumberInvalid;
    } else {
      return PhoneNumberStatus.phoneNumberValid;
    }
  }

  // labelText를 반환하는 메소드
  String labelText(bool authCompleted) {
    printd("phoneNumber: $phoneNumber");
    if (isPhoneNumberAvailable != null && !isPhoneNumberAvailable!) {
      return "status.phoneNumber.notAvailable".tr();
    } else if (authCompleted) {
      return "status.phoneNumber.available".tr();
    } else if (isPhoneNumberValid) {
      return "status.phoneNumber.valid".tr();
    } else {
      return "status.phoneNumber.empty".tr();
    }
  }

  static initial() {
    return UserPhoneModel(
      dialCode: "+82",
      isoCode: "KR",
      phoneNumber: null,
    );
  }

  /// ### 전화번호에 -를 제거하여 String 반환하는 메서드
  ///
  /// 전화번호에 -를 제거하여 String을 반환한다.
  ///
  /// #### Returns
  ///
  /// [String] 전화번호
  ///
  String? getPhoneNumberWithFormat() {
    if (phoneNumber == null || (phoneNumber?.isEmpty ?? true)) {
      return null;
    }

    if (phoneNumber?[0] == "0") {
      return phoneNumber?.substring(1).replaceAll("-", "");
    }
    return phoneNumber?.replaceAll("-", "");
  }
}
