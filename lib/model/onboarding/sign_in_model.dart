import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';

enum SignInStatus {
  loginFailedForInvalidLoginInfo,
  loginFailedForServer,
  loginSuccess,
  logout,
}

extension SignInStatusExtension on SignInStatus {
  String get toMessage {
    return "status.signIn.${toString().split('.').last}";
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
    SignInStatus? signInStatus,
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
