import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

final nicknameStateProvider =
    StateNotifierProvider<NicknameStateNotifier, UserNicknameModel>((ref) {
  return NicknameStateNotifier(ref);
});

class NicknameStateNotifier extends StateNotifier<UserNicknameModel> {
  late Ref ref;
  final TextEditingController nicknameController = TextEditingController();
  String? nicknameBackup;

  NicknameStateNotifier(this.ref) : super(UserNicknameModel.initial()) {
    readFromDB();
  }

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void enableEditing() {
    state = state.copyWith(isEditing: true);
  }

  void disableEditing() {
    state = state.copyWith(isEditing: false);
  }

  void clearNickname() {
    state = UserNicknameModel.initial();
  }

  void readFromDB() {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData != null) {
      updateNickname(userData.userNickName);
      nicknameController.text = userData.userNickName;
    }
  }

  UserNicknameModel get getNickNameModel => state;
}

extension NicknameAction on NicknameStateNotifier {
  /// ### Nickname 입력 onChange 이벤트
  ///
  /// #### Notes
  /// - Nickname 입력 필드의 onChange 이벤트 발생 시 호출
  /// - 입력된 Nickname을 업데이트
  ///
  /// #### Parameters
  ///
  /// - `String nickname`: 입력된 Nickname
  ///
  void onChangeNickname(String nickname) {
    updateNickname(nickname);
  }

  /// ### Nickname 변경 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - Nickname 변경 버튼 클릭 시 호출
  /// - textfield를 enable 상태로 변경
  /// - 현재 Nickname을 백업
  ///
  void onClickChangeNickname() {
    nicknameBackup = getNickNameModel.nickname;
    enableEditing();
    printd("Nickname backup: $nicknameBackup");
  }

  /// ### Nickname 변경 취소 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - Nickname 변경 취소 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경되기 전의 Nickname으로 업데이트
  ///
  void onClickCancelChangeNickname() {
    printd("Nickname backup: $nicknameBackup");
    updateNickname(nicknameBackup ?? "");
    nicknameController.text = nicknameBackup ?? "";
    disableEditing();
  }

  /// ### Nickname 변경 완료 버튼 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - Nickname 변경 완료 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경된 Nickname으로 업데이트
  /// - 변경된 Nickname을 서버로 전송
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  /// #### Returns
  ///
  /// - [VoidCallback?] : textfield를 disable 상태로 변경하는 콜백 함수 (validation check 결과가 false라면 null 반환)
  ///
  VoidCallback? onClickCompleteChangeNickname(BuildContext context) {
    if (!getNickNameModel.isValid) {
      return null;
    }

    return () async {
      final userData = ref.read(userDetailInfoStateProvider);
      final userPassword =
          await SecureStorageService.readSecureData(SecureModel.userPassword);

      if (userData == null || userPassword == null) {
        printd("UserDetailInfoModel or userPassword is null");
        return;
      }

      final updatedUserData =
          userData.copyWith(userNickName: getNickNameModel.nickname);

      await ref
          .read(userDetailInfoStateProvider.notifier)
          .update(updatedUserData);

      final result =
          await UserService.updateUser(updatedUserData, userPassword);

      if (result) {
        printd("Nickname update success");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateSuccess", context);
          disableEditing();
          nicknameBackup = null;
        }
      } else {
        printd("Nickname update failed");
        onClickCancelChangeNickname();
        onClickChangeNickname();
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "error.server.description", context);
        }
      }
    };
  }
}
