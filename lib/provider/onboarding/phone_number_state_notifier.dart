import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/model/user/user_phone_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

final phoneNumberStateProvider = StateNotifierProvider.family
    .autoDispose<PhoneNumberStateNotififer, UserPhoneModel, bool>(
  (ref, isEditing) => PhoneNumberStateNotififer(ref, isEditing),
);

class PhoneNumberStateNotififer extends StateNotifier<UserPhoneModel> {
  late final Ref ref;
  String? phoneNumberBackup;
  final TextEditingController phoneNumberController = TextEditingController();
  PhoneNumberStateNotififer(this.ref, isEditing)
      : super(UserPhoneModel.initial()) {
    if (isEditing) {
      readFromDB();
    }
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateCountryCode(CountryCode countryCode) {
    state = state.copyWith(
        dialCode: countryCode.dialCode, isoCode: countryCode.code);
  }

  void reset() {
    state = UserPhoneModel.initial();
  }

  void enableEditing() {
    state = state.copyWith(isEditing: true);
  }

  void disableEditing() {
    state = state.copyWith(isEditing: false);
  }

  void readFromDB() {
    final userData = ref.read(userDetailInfoStateProvider);

    if (userData != null) {
      updatePhoneNumber(userData.userPhoneNumber);
      phoneNumberController.text = userData.userPhoneNumber;
    }
  }

  UserPhoneModel get getPhoneNumberModel => super.state;
}

extension PhoneNumberAction on PhoneNumberStateNotififer {
  /// ### PhoneNumber 입력 onChange 이벤트
  ///
  /// #### Notes
  /// - PhoneNumber 입력 필드의 onChange 이벤트 발생 시 호출
  /// - 입력된 PhoneNumber를 업데이트
  ///
  /// #### Parameters
  ///
  /// - `String phoneNumber`: 입력된 PhoneNumber
  ///
  void onChangePhoneNumber(String phoneNumber) {
    updatePhoneNumber(phoneNumber);
  }

  /// ### PhoneNumber 변경 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - PhoneNumber 변경 버튼 클릭 시 호출
  /// - textfield를 enable 상태로 변경
  /// - 현재 PhoneNumber을 백업
  ///
  void onClickChangePhoneNumber() {
    phoneNumberBackup = getPhoneNumberModel.phoneNumber;
    enableEditing();
    printd("PhoneNumber backup: $phoneNumberBackup");
  }

  /// ### PhoneNumber 변경 취소 버튼 클릭 이벤트
  ///
  /// #### Notes
  /// - PhoneNumber 변경 취소 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경되기 전의 PhoneNumber으로 업데이트
  ///
  void onClickCancelChangePhoneNumber() {
    printd("PhoneNumber backup: $phoneNumberBackup");
    updatePhoneNumber(phoneNumberBackup ?? "");
    phoneNumberController.text = phoneNumberBackup ?? "";
    disableEditing();
  }

  /// ### PhoneNumber 변경 완료 버튼 클릭 이벤트
  ///
  /// #### Notes
  ///
  /// - PhoneNumber 변경 완료 버튼 클릭 시 호출
  /// - textfield를 disable 상태로 변경
  /// - 변경된 PhoneNumber으로 업데이트
  /// - 변경된 PhoneNumber을 서버로 전송
  ///
  /// #### Parameters
  ///
  /// - `BuildContext context`: BuildContext
  ///
  /// #### Returns
  ///
  /// - [VoidCallback?] : textfield를 disable 상태로 변경하는 콜백 함수 (validation check 결과가 false라면 null 반환)
  ///
  VoidCallback? onClickCompleteChangePhoneNumber(BuildContext context) {
    if (!getPhoneNumberModel.isValid) {
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
          userData.copyWith(userPhoneNumber: getPhoneNumberModel.phoneNumber);

      await ref
          .read(userDetailInfoStateProvider.notifier)
          .update(updatedUserData);

      final result =
          await UserService.updateUser(updatedUserData, userPassword);

      if (result) {
        printd("PhoneNumber update success");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "status.UserServiceStatus.updateSuccess", context);
          disableEditing();
          phoneNumberBackup = null;
        }
      } else {
        printd("PhoneNumber update failed");
        onClickCancelChangePhoneNumber();
        onClickChangePhoneNumber();
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "error.server.description", context);
        }
      }
    };
  }
}
