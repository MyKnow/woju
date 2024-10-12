import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';

class UserProfileEditState {
  final Uint8List? userImage;
  final Uint8List? userImageBackup;

  final UserNicknameModel userNicknameModel;
  final String? userNicknameBackup;
  final TextEditingController userNicknameController;

  final Gender userGender;
  final Gender? userGenderBackup;

  final DateTime userBirthDate;
  final DateTime? userBirthDateBackup;

  final bool isEditing;
  final bool isLoading;

  UserProfileEditState({
    required this.userImage,
    this.userImageBackup,
    required this.userNicknameModel,
    this.userNicknameBackup,
    required this.userNicknameController,
    required this.userGender,
    this.userGenderBackup,
    required this.userBirthDate,
    this.userBirthDateBackup,
    required this.isEditing,
    required this.isLoading,
  });

  UserProfileEditState copyWith({
    Uint8List? userImage,
    Uint8List? userImageBackup,
    bool? userImageClear,
    UserNicknameModel? userNicknameModel,
    String? userNicknameBackup,
    TextEditingController? userNicknameController,
    Gender? userGender,
    Gender? userGenderBackup,
    DateTime? userBirthDate,
    DateTime? userBirthDateBackup,
    bool? isEditing,
    bool? isBackupClear,
    bool? isLoading,
  }) {
    if (isBackupClear == true) {
      return UserProfileEditState(
        userImage: this.userImage,
        userNicknameModel: this.userNicknameModel,
        userNicknameController: this.userNicknameController,
        userGender: this.userGender,
        userBirthDate: this.userBirthDate,
        userImageBackup: null,
        userNicknameBackup: null,
        userGenderBackup: null,
        userBirthDateBackup: null,
        isEditing: this.isEditing,
        isLoading: this.isLoading,
      );
    } else {
      return UserProfileEditState(
        userImage: userImageClear == true ? null : userImage ?? this.userImage,
        userImageBackup: userImageBackup ?? this.userImageBackup,
        userNicknameModel: userNicknameModel ?? this.userNicknameModel,
        userNicknameBackup: userNicknameBackup ?? this.userNicknameBackup,
        userNicknameController:
            userNicknameController ?? this.userNicknameController,
        userGender: userGender ?? this.userGender,
        userGenderBackup: userGenderBackup ?? this.userGenderBackup,
        userBirthDate: userBirthDate ?? this.userBirthDate,
        userBirthDateBackup: userBirthDateBackup ?? this.userBirthDateBackup,
        isEditing: isEditing ?? this.isEditing,
        isLoading: isLoading ?? this.isLoading,
      );
    }
  }

  static UserProfileEditState initial() {
    return UserProfileEditState(
      userImage: null,
      userNicknameModel: UserNicknameModel.initial(),
      userNicknameController: TextEditingController(),
      userGender: Gender.private,
      userBirthDate: DateTime.now(),
      isEditing: false,
      isLoading: false,
    );
  }
}
