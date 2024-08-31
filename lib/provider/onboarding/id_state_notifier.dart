import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

final userIDStateProvider =
    StateNotifierProvider<UserIDStateNotifier, UserIDModel>((ref) {
  return UserIDStateNotifier(ref);
});

class UserIDStateNotifier extends StateNotifier<UserIDModel> {
  late Ref ref;
  final TextEditingController userIDController = TextEditingController();
  String? userIDBackup;

  UserIDStateNotifier(this.ref) : super(UserIDModel.initial()) {
    readFromDB();
  }

  void updateUserID(String userID) {
    state = state.copyWith(userID: userID);
  }

  void enableEditing() {
    state = state.copyWith(isEditing: true);
  }

  void disableEditing() {
    state = state.copyWith(isEditing: false);
  }

  void clearUserID() {
    state = UserIDModel.initial();
  }

  void readFromDB() {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData != null) {
      updateUserID(userData.userID);
      userIDController.text = userData.userID;
    }
  }

  UserIDModel get getUserIDModel => state;
}

extension UserIDAction on UserIDStateNotifier {
  /// ### UserID 입력 onChange 이벤트
  ///
  /// #### Notes
  /// - UserID 입력 필드의 onChange 이벤트 발생 시 호출
  /// - 입력된 UserID을 업데이트
  ///
  /// #### Parameters
  ///
  /// - `String userID`: 입력된 UserID
  ///
  void onChangeUserID(String userID) {
    updateUserID(userID);
  }

  /// ### UserID 변경 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - UserID 변경 버튼 클릭 시 호출
  /// - textfield를 enable 상태로 변경
  /// - 현재 UserID을 백업
  ///
  void onClickChangeUserID() {
    userIDBackup = getUserIDModel.userID;
    enableEditing();
    printd("UserID backup: $userIDBackup");
  }

  /// ### UserID 변경 취소 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - UserID 변경 취소 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경되기 전의 UserID으로 업데이트
  ///
  void onClickCancelChangeUserID() {
    printd("UserID backup: $userIDBackup");
    updateUserID(userIDBackup ?? "");
    userIDController.text = userIDBackup ?? "";
    disableEditing();
  }

  /// ### UserID 변경 완료 버튼 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - UserID 변경 완료 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경된 UserID으로 업데이트
  /// - 변경된 UserID을 서버로 전송
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  /// #### Returns
  ///
  /// - [VoidCallback?] : textfield를 disable 상태로 변경하는 콜백 함수 (validation check 결과가 false라면 null 반환)
  ///
  VoidCallback? onClickCompleteChangeUserID(BuildContext context) {
    if (!getUserIDModel.isValid) {
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
          userData.copyWith(userNickName: getUserIDModel.userID);

      await ref
          .read(userDetailInfoStateProvider.notifier)
          .update(updatedUserData);

      final result =
          await UserService.updateUser(updatedUserData, userPassword);

      if (result) {
        printd("ID update success");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateSuccess", context);
          disableEditing();
          userIDBackup = null;
        }
      } else {
        printd("UserID update failed");
        onClickCancelChangeUserID();
        onClickChangeUserID();
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "error.server.description", context);
        }
      }
    };
  }
}
