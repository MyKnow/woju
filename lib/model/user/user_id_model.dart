import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/api/http_service.dart';

/// ### UserIDStatus
///
/// - 유저 아이디 상태를 나타내는 열거형
///
/// #### Values
/// - [empty]: 유저 아이디가 비어있는 경우
/// - [short]: 유저 아이디가 너무 짧은 경우
/// - [long]: 유저 아이디가 너무 긴 경우
/// - [invalid]: 유저 아이디가 유효하지 않은 경우
/// - [invalidAlphabetFirst]: 유저 아이디가 영어로 시작하지 않는 경우
/// - [validIDFormat]: 유저 아이디가 유효한 형식인 경우
/// - [notAvailable]: 유저 아이디가 이미 사용 중인 경우
/// - [available]: 유저 아이디가 사용 가능한 경우
/// - [serverError]: 서버 에러가 발생한 경우
/// - [validForSignUp]: 회원가입 시 유효한 경우
/// - [validForDisabled]: 회원가입 시 유효하지 않은 경우
///
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

/// ### UserIDModel
///
/// - 유저 아이디 상태를 관리하는 모델
///
/// #### Fields
/// - [String]? userID: 유저 아이디
/// - [bool] isIDValid: 유저 아이디 유효성 여부
/// - [bool] isIDAvailable: 유저 아이디 중복 여부
/// - [bool] isEditing: 유저 아이디 입력 상태
///
/// #### Static Fields
/// - [int] minLength: 유저 아이디 최소 길이 (6)
/// - [int] maxLength: 유저 아이디 최대 길이 (20)
///
/// #### Methods
/// - [UserIDModel] copyWith({[String]? userID, [bool]? isIDAvailable, [bool]? isEditing}): 유저 아이디 모델 복사
/// - [UserIDStatus] validateID([String]? userID): 유저 아이디 유효성 검사
/// - Future<[UserIDStatus]> checkAvailableID([String]? userID, [String]? userUID): 유저 아이디 중복 여부 확인
/// - [UserIDModel] initial(): 유저 아이디 모델 초기화
/// - [String] labelTextWithParameter([bool] isSignUp): 유저 아이디 라벨 텍스트 반환
///
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
          await HttpService.userPost("/user/check-userid-available", json);

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
      UserIDStatus status = validateID(value as String?);
      if (status == UserIDStatus.validIDFormat) {
        return null;
      } else {
        return status.toMessage;
      }
    };
  }

  List<TextInputFormatter>? get inputFormatters {
    return [
      // 소문자, 숫자만 입력 가능
      FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
      // 최대 20자까지 입력 가능
      LengthLimitingTextInputFormatter(20),
    ];
  }
}
