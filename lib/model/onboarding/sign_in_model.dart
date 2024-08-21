import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';

enum SignInError {
  invalidLoginInfo,
  invalidUserID,
  serverError,
}

extension SignInErrorExtension on SignInError {
  String get toMessage {
    switch (this) {
      case SignInError.invalidLoginInfo:
        return "onboarding.signIn.error.invalidLoginInfo";
      default:
        return "onboarding.signIn.error.serverError";
    }
  }
}

class SignInModel {
  final UserPhoneModel userPhoneModel;
  final UserPasswordModel userPasswordModel;
  final UserIDModel userIDModel;
  final bool loginWithPhoneNumber;

  SignInModel({
    required this.userPhoneModel,
    required this.userPasswordModel,
    required this.userIDModel,
    this.loginWithPhoneNumber = false,
  });

  SignInModel copyWith({
    UserPhoneModel? userPhoneModel,
    UserPasswordModel? userPasswordModel,
    UserIDModel? userIDModel,
    bool? loginWithPhoneNumber,
  }) {
    return SignInModel(
      userPhoneModel: userPhoneModel ?? this.userPhoneModel,
      userPasswordModel: userPasswordModel ?? this.userPasswordModel,
      userIDModel: userIDModel ?? this.userIDModel,
      loginWithPhoneNumber: loginWithPhoneNumber ?? this.loginWithPhoneNumber,
    );
  }

  static SignInModel initial() {
    return SignInModel(
      userPhoneModel: UserPhoneModel.initial(),
      userPasswordModel: UserPasswordModel.initial(),
      userIDModel: UserIDModel.initial(),
      loginWithPhoneNumber: false,
    );
  }
}
