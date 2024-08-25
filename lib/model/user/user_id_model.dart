import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/api/http_service.dart';

enum UserIDStatus with StatusMixin {
  empty,
  short,
  long,
  invalid,
  valid,
  notAvailable,
  available,
  serverError,
  validForSignUp,
}

class UserIDModel with TextFieldModel<String> {
  final String? userID;
  final bool isIDValid;
  final bool isIDAvailable;

  static const int minLength = 6;
  static const int maxLength = 20;

  UserIDModel({
    this.userID,
    this.isIDAvailable = false,
  }) : isIDValid = validateID(userID) == UserIDStatus.valid;

  UserIDModel copyWith({
    String? userID,
    bool? isIDAvailable,
  }) {
    return UserIDModel(
      userID: userID ?? this.userID,
      isIDAvailable: isIDAvailable ?? this.isIDAvailable,
    );
  }

  static UserIDStatus validateID(String? userID) {
    if (userID == null) {
      return UserIDStatus.empty;
    }

    if (userID.isEmpty) {
      return UserIDStatus.empty;
    } else if (userID.length < minLength) {
      return UserIDStatus.short;
    } else if (userID.length > maxLength) {
      return UserIDStatus.long;
    } else if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userID) == false) {
      return UserIDStatus.invalid;
    } else {
      return UserIDStatus.valid;
    }
  }

  static Future<UserIDStatus> checkAvailableID(
      String? userID, String? userUID) async {
    if (validateID(userID) != UserIDStatus.valid) {
      return validateID(userID);
    }

    final json = {
      "userID": userID,
      "userUID": userUID,
    };

    // 백엔드로 ID 전송
    try {
      final response =
          await HttpService.post("/user/check-userid-available", json);

      printd("checkDuplicateID: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["isAvailable"] == true) {
          printd("사용 가능한 ID");
          return UserIDStatus.available;
        } else {
          printd("사용 불가능한 ID");
          return UserIDStatus.notAvailable;
        }
      } else {
        printd("ID 중복 여부 확인 실패");
        return UserIDStatus.serverError;
      }
    } catch (e) {
      printd("ID 중복 여부 확인 실패 (json Error): $e");
      return UserIDStatus.serverError;
    }
  }

  static UserIDModel initial() {
    return UserIDModel();
  }

  @override
  String get labelText;

  String labelTextWithParameter(bool isSignUp) {
    if (isIDValid) {
      if (isSignUp == true) {
        return "status.UserIDStatus.validForSignUp".tr();
      } else {
        return "status.UserIDStatus.validForSignIn".tr();
      }
    } else {
      return validateID(userID).toMessage;
    }
  }

  @override
  bool get isValid => validateID(userID) == UserIDStatus.valid;

  @override
  String? get value => userID;

  @override
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return validateID(userID).toMessage;
    }
  }
}
