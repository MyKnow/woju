import 'dart:convert';

import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/api/http_service.dart';

enum UserIDStatus with StatusMixin {
  empty,
  short,
  long,
  invalid,
  invalidAlphabetFirst,
  validIDFormat,
  notAvailable,
  available,
  serverError,
  validForSignUp,
  validForDisabled,
}

class UserIDModel with TextFieldModel<String> {
  final String? userID;
  final bool isIDValid;
  final bool isIDAvailable;
  final bool isEditing;

  static const int minLength = 6;
  static const int maxLength = 20;

  UserIDModel({
    this.userID,
    this.isIDAvailable = false,
    this.isEditing = false,
  }) : isIDValid = validateID(userID) == UserIDStatus.validIDFormat;

  UserIDModel copyWith({
    String? userID,
    bool? isIDAvailable,
    bool? isEditing,
  }) {
    return UserIDModel(
      userID: userID ?? this.userID,
      isIDAvailable: isIDAvailable ?? this.isIDAvailable,
      isEditing: isEditing ?? this.isEditing,
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
    } else if (RegExp(r'^[a-z0-9]+$').hasMatch(userID) == false) {
      return UserIDStatus.invalid;
    } else {
      return UserIDStatus.validIDFormat;
    }
  }

  static Future<UserIDStatus> checkAvailableID(
      String? userID, String? userUID) async {
    if (validateID(userID) != UserIDStatus.validIDFormat) {
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
        return UserIDStatus.validForSignUp.toMessage;
      } else {
        return UserIDStatus.validIDFormat.toMessage;
      }
    } else {
      return UserIDStatus.empty.toMessage;
    }
  }

  @override
  bool get isValid => validateID(userID) == UserIDStatus.validIDFormat;

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

  String? get labelTextForEditing {
    if (isValid) {
      if (isEditing) {
        return UserIDStatus.validIDFormat.toMessage;
      } else {
        return UserIDStatus.validForDisabled.toMessage;
      }
    } else {
      return UserIDStatus.empty.toMessage;
    }
  }

  @override
  String? Function(dynamic)? get validator {
    return (value) {
      if (isValid) {
        return null;
      } else {
        return validateID(userID).toMessage;
      }
    };
  }
}
