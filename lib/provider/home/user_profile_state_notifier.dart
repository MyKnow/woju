import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/debug_service.dart';
import 'package:easy_localization/easy_localization.dart';

class UserProfileEditState {
  final Uint8List? userImage;
  final UserNicknameModel userNicknameModel;
  final TextEditingController userNicknameController;
  final Gender userGender;
  final DateTime userBirthDate;
  final bool isEditing;

  UserProfileEditState({
    required this.userImage,
    required this.userNicknameModel,
    required this.userNicknameController,
    required this.userGender,
    required this.userBirthDate,
    required this.isEditing,
  });

  UserProfileEditState copyWith({
    Uint8List? userImage,
    bool? userImageClear,
    UserNicknameModel? userNicknameModel,
    TextEditingController? userNicknameController,
    Gender? userGender,
    DateTime? userBirthDate,
    bool? isEditing,
  }) {
    return UserProfileEditState(
      userImage: userImageClear == true ? null : userImage ?? this.userImage,
      userNicknameModel: userNicknameModel ?? this.userNicknameModel,
      userNicknameController:
          userNicknameController ?? this.userNicknameController,
      userGender: userGender ?? this.userGender,
      userBirthDate: userBirthDate ?? this.userBirthDate,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  static UserProfileEditState initial() {
    return UserProfileEditState(
      userImage: null,
      userNicknameModel: UserNicknameModel.initial(),
      userNicknameController: TextEditingController(),
      userGender: Gender.private,
      userBirthDate: DateTime.now(),
      isEditing: false,
    );
  }
}

final userProfileStateNotifierProvider = StateNotifierProvider.autoDispose<
    UserProfileStateNotifier, UserProfileEditState>((ref) {
  return UserProfileStateNotifier(ref);
});

class UserProfileStateNotifier extends StateNotifier<UserProfileEditState> {
  late Ref ref;
  UserProfileStateNotifier(this.ref) : super(UserProfileEditState.initial()) {
    readFromDB();
  }

  void readFromDB() async {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData != null) {
      printd('UserProfileStateNotifier readFromDB: $userData');

      updateUserImage(userData.profileImage);
      updateUserNicknameModel(userData.userNickName, false);
      updateUserNicknameController(userData.userNickName);
      updateUserGenderModel(userData.userGender);
      updateUserBirthDate(userData.userBirthDate);
    }
  }

  void updateUserImage(Uint8List? userImage) {
    if (userImage == null) {
      state = state.copyWith(userImage: null, userImageClear: true);
    } else {
      state = state.copyWith(userImage: userImage, userImageClear: false);
    }
  }

  void updateUserNicknameModel(String? userNickName, bool? isEditing) {
    final userNicknameModel = state.userNicknameModel;

    state = state.copyWith(
      userNicknameModel: userNicknameModel.copyWith(
          nickname: userNickName, isEditing: isEditing),
    );
  }

  void updateUserNicknameController(String userNickName) {
    state.userNicknameController.text = userNickName;
  }

  void updateUserGenderModel(Gender userGender) {
    state = state.copyWith(userGender: userGender);
  }

  void updateUserBirthDate(DateTime userBirthDate) {
    state = state.copyWith(userBirthDate: userBirthDate);
  }

  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  List<String> getGenderList() {
    return Gender.values.map((e) => e.toMessage.tr()).toList();
  }
}

extension UserProfileEditAction on UserProfileStateNotifier {
  void onClickSaveProfile(BuildContext context) {
    toggleEditing();
  }

  void onClickEditProfile(BuildContext context) {
    toggleEditing();
  }
}
