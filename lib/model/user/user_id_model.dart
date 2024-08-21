import 'dart:convert';

import 'package:woju/service/debug_service.dart';
import 'package:woju/service/http_service.dart';

enum UserIDStatus {
  userIDEmpty,
  userIDShort,
  userIDLong,
  userIDInvalid,
  userIDValid,
  userIDNotAvailable,
  userIDAvailable,
  serverError,
}

extension UserIDStatusExtension on UserIDStatus {
  String get toMessage {
    switch (this) {
      case UserIDStatus.userIDEmpty:
        return "status.userID.empty";
      case UserIDStatus.userIDShort:
        return "status.userID.short";
      case UserIDStatus.userIDLong:
        return "status.userID.long";
      case UserIDStatus.userIDInvalid:
        return "status.userID.invalid";
      case UserIDStatus.userIDValid:
        return "status.userID.valid";
      case UserIDStatus.userIDNotAvailable:
        return "status.userID.notAvailable";
      case UserIDStatus.userIDAvailable:
        return "status.userID.available";
      case UserIDStatus.serverError:
        return "status.server.error";
    }
  }
}

class UserIDModel {
  final String? userID;
  final bool isIDValid;
  final bool isIDAvailable;

  static const int minLength = 6;
  static const int maxLength = 20;

  UserIDModel({
    this.userID,
    this.isIDAvailable = false,
  }) : isIDValid = validateID(userID) == UserIDStatus.userIDValid;

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
      return UserIDStatus.userIDEmpty;
    }

    if (userID.isEmpty) {
      return UserIDStatus.userIDEmpty;
    } else if (userID.length < minLength) {
      return UserIDStatus.userIDShort;
    } else if (userID.length > maxLength) {
      return UserIDStatus.userIDLong;
    } else if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userID) == false) {
      return UserIDStatus.userIDInvalid;
    } else {
      return UserIDStatus.userIDValid;
    }
  }

  static Future<UserIDStatus> checkAvailableID(
      String? userID, String? userUID) async {
    if (validateID(userID) != UserIDStatus.userIDValid) {
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
          return UserIDStatus.userIDAvailable;
        } else {
          printd("사용 불가능한 ID");
          return UserIDStatus.userIDNotAvailable;
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

  String labelText(bool isSignUp) {
    if (isIDValid) {
      if (isSignUp) {
        return "status.userID.validForSignUp";
      } else {
        return "status.userID.validForSignIn";
      }
    } else {
      return "onboarding.signIn.inputUserID";
    }
  }
}
