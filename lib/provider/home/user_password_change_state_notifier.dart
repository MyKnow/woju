import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/user/user_password_change_model.dart';

import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/http_service.dart';

import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/toast_message_service.dart';

final userPasswordChangeStateProvider = StateNotifierProvider.autoDispose<
    UserPasswordChangeStateNotifier, UserPasswordChangeModel>(
  (ref) => UserPasswordChangeStateNotifier(ref),
);

/// ### UserPasswordChangeStateNotifier
///
/// - 비밀번호 변경 페이지에서 사용하는 StateNotifier
///
/// #### Fields
///
/// - [state]: 비밀번호 변경 모델 상태
/// - [ref]: Riverpod Ref
///
/// #### Methods
///
/// - [updateCurrentPassword]: 현재 비밀번호 업데이트
/// - [updateNewPassword]: 새로운 비밀번호 업데이트
/// - [updateVisibleCurrentPassword]: 현재 비밀번호 보임 여부 토글
/// - [updateVisibleNewPassword]: 새로운 비밀번호 보임 여부 토글
/// - [updateLoading]: 로딩 상태 업데이트
/// - [reset]: 초기화
/// - [getUserPasswordChangeModel]: 비밀번호 변경 모델 반환
///
class UserPasswordChangeStateNotifier
    extends StateNotifier<UserPasswordChangeModel> {
  late Ref ref;
  UserPasswordChangeStateNotifier(this.ref)
      : super(UserPasswordChangeModel.initial());

  void updateCurrentPassword(String password) {
    state = state.copyWith(
      currentPassword: state.currentPassword.copyWith(password: password),
    );
  }

  void updateNewPassword(String password) {
    state = state.copyWith(
      newPassword: state.newPassword.copyWith(password: password),
    );
  }

  void updateVisibleCurrentPassword() {
    state = state.copyWith(
      currentPassword: state.currentPassword.copyWith(
        isPasswordVisible: !state.currentPassword.isPasswordVisible,
      ),
    );
  }

  void updateVisibleNewPassword() {
    state = state.copyWith(
      newPassword: state.newPassword.copyWith(
        isPasswordVisible: !state.newPassword.isPasswordVisible,
      ),
    );
  }

  void updateLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void reset() {
    state = UserPasswordChangeModel.initial();
  }

  UserPasswordChangeModel get getUserPasswordChangeModel => state;
}

/// ### Password Page에서의 Action을 정의하는 Extension
///
/// #### Methods
///
/// - [onChangeUpdatePassword]: 비밀번호 입력 시 observable을 업데이트하는 함수
/// - [onPressedUpdateVisiblePassword]: 비밀번호 보임 여부 토글 함수
/// - [onPressedChangePasswordAPI]: 비밀번호 변경 API 호출 버튼
///
extension UserPasswordChangeAction on UserPasswordChangeStateNotifier {
  /// ### 비밀번호 입력 시 observable을 업데이트하는 함수
  ///
  /// #### Notes
  ///
  /// - 현재 비밀번호와 새로운 비밀번호를 입력할 때 사용하는 함수
  /// - 현재 비밀번호와 새로운 비밀번호를 구분하기 위해 fieldKey를 사용
  ///
  /// #### Parameters
  /// - [fieldKey] : 현재 비밀번호인지 새로운 비밀번호인지 구분하는 key
  ///
  void onPressedUpdateVisiblePassword(String fieldKey) {
    if (fieldKey == getUserPasswordChangeModel.currentPasswordFieldKey) {
      updateVisibleCurrentPassword();
    } else {
      updateVisibleNewPassword();
    }
  }

  /// ### 비밀번호 입력 시 호출되는 함수
  ///
  /// #### Notes
  ///
  /// - 현재 비밀번호와 새로운 비밀번호를 입력할 때 사용하는 함수
  ///
  /// #### Parameters
  ///
  /// - [String fieldKey] : 현재 비밀번호인지 새로운 비밀번호인지 구분하는 key
  /// - [String password] : 입력한 비밀번호
  ///
  void onChangeUpdatePassword(String fieldKey, String password) {
    if (fieldKey == getUserPasswordChangeModel.currentPasswordFieldKey) {
      updateCurrentPassword(password);
    } else {
      updateNewPassword(password);
    }
  }

  /// ### 비밀번호 변경 API 호출 버튼
  ///
  /// #### Notes
  ///
  /// - 변경 버튼을 눌러서 비밀번호 변경 API를 호출한다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext context] SnackBar 호출을 위한 BuildContext
  ///
  /// #### Return
  ///
  /// - [VoidCallback?] currentPassword와 NewPassword의 Validation이 통과되지 못하면 null 반환, 통과하면 콜백 함수를 반환한다.
  ///
  VoidCallback? onPressedChangePasswordAPI(BuildContext context) {
    if (!getUserPasswordChangeModel.currentPassword.isValid ||
        !getUserPasswordChangeModel.newPassword.isValid) {
      return null;
    }

    return () async {
      final userData = ref.watch(userDetailInfoStateProvider);
      final userDataStatus =
          ref.watch(userDetailInfoStateProvider.notifier).getErrorMessage;

      if (userData == null && userDataStatus != null) {
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(userDataStatus, context);
        }
        return;
      } else {
        final userID = userData?.userID as String;
        final oldPassword =
            getUserPasswordChangeModel.currentPassword.userPassword as String;
        final newPassword =
            getUserPasswordChangeModel.newPassword.userPassword as String;
        final result = await UserService.changePassword(
            userID, oldPassword, newPassword, ref);

        if (result == null) {
          if (context.mounted) {
            ToastMessageService.nativeSnackbar(
                "status.UserServiceStatus.updateSuccess", context);
            context.pop();
          }
        } else {
          if (context.mounted) {
            ToastMessageService.nativeSnackbar(
                HttpService.failureReason(result), context);
          }
        }
      }
    };
  }
}
