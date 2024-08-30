import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';

enum PhoneNumberStatus with StatusMixin {
  lengthInvalid,
  invalid,
  valid,
  notAvailable,
  authCompleted,
  empty,
  countrycodeEmpty,
  validForDisabled,
}

class UserPhoneModel with TextFieldModel {
  final String dialCode;
  final String isoCode;
  final String? phoneNumber;
  final bool isPhoneNumberValid;
  final bool? isPhoneNumberAvailable;
  final bool isEditing;

  UserPhoneModel({
    required this.dialCode,
    required this.isoCode,
    required this.phoneNumber,
    this.isPhoneNumberAvailable,
    this.isEditing = false,
  }) : isPhoneNumberValid =
            phoneNumberValidation(phoneNumber) == PhoneNumberStatus.valid;

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
    bool? isEditing,
  }) {
    if (dialCode != null && isoCode != null) {
      return UserPhoneModel(
        dialCode: dialCode,
        isoCode: isoCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
        isEditing: isEditing ?? this.isEditing,
      );
    } else if (phoneNumber != null) {
      return UserPhoneModel(
        dialCode: this.dialCode,
        isoCode: this.isoCode,
        phoneNumber: phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
        isEditing: isEditing ?? this.isEditing,
      );
    } else {
      return UserPhoneModel(
        dialCode: this.dialCode,
        isoCode: this.isoCode,
        phoneNumber: this.phoneNumber,
        isPhoneNumberAvailable:
            isPhoneNumberAvailable ?? this.isPhoneNumberAvailable,
        isEditing: isEditing ?? this.isEditing,
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
      return PhoneNumberStatus.lengthInvalid;
    } else if (value.contains(RegExp(r'[^\d]'))) {
      // 숫자가 아닌 다른 문자가 포함되어 있는 경우
      return PhoneNumberStatus.invalid;
    } else {
      return PhoneNumberStatus.valid;
    }
  }

  String labelTextWithParameter(bool authCompleted) {
    if (isPhoneNumberAvailable != null && !isPhoneNumberAvailable!) {
      return PhoneNumberStatus.notAvailable.toMessage;
    } else if (authCompleted) {
      return PhoneNumberStatus.authCompleted.toMessage;
    } else if (isPhoneNumberValid) {
      return PhoneNumberStatus.valid.toMessage;
    } else {
      return PhoneNumberStatus.empty.toMessage;
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
      return phoneNumber?.substring(1);
    }
    return phoneNumber?.replaceAll("-", "");
  }

  @override
  bool get isValid =>
      phoneNumberValidation(phoneNumber) == PhoneNumberStatus.valid;

  @override
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return phoneNumberValidation(phoneNumber).toMessage;
    }
  }

  @override
  get value => phoneNumber;

  String? get labelTextForEditing {
    if (isValid) {
      if (isEditing) {
        return PhoneNumberStatus.valid.toMessage;
      } else {
        return PhoneNumberStatus.validForDisabled.toMessage;
      }
    } else {
      return PhoneNumberStatus.empty.toMessage;
    }
  }
}
