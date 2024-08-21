enum PasswordStatus {
  passwordEmpty,
  passwordShort,
  passwordLong,
  passwordInvalid,
  passwordValid,
}

extension PasswordErrorExtension on PasswordStatus {
  String? get toMessage {
    switch (this) {
      case PasswordStatus.passwordEmpty:
        return "onboarding.signUp.error.passwordEmpty";
      case PasswordStatus.passwordShort:
        return "onboarding.signUp.error.passwordShort";
      case PasswordStatus.passwordLong:
        return "onboarding.signUp.error.passwordLong";
      case PasswordStatus.passwordInvalid:
        return "onboarding.signUp.error.passwordInvalid";
      case PasswordStatus.passwordValid:
        return null;
      default:
        return null;
    }
  }
}

class UserPasswordModel {
  final String? userPassword;
  final PasswordStatus? passwordError;
  final bool isPasswordVisible;
  final bool isPasswordAvailable;

  static const int minLength = 8;
  static const int maxLength = 20;

  UserPasswordModel({
    this.userPassword,
    this.passwordError,
    this.isPasswordVisible = false,
  }) : isPasswordAvailable =
            validatePassword(userPassword) == PasswordStatus.passwordValid;

  UserPasswordModel copyWith({
    String? password,
    PasswordStatus? passwordError,
    bool? isPasswordVisible,
  }) {
    return UserPasswordModel(
      userPassword: password ?? userPassword,
      passwordError: passwordError ?? this.passwordError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  static PasswordStatus validatePassword(String? password) {
    if (password == null) {
      return PasswordStatus.passwordEmpty;
    }

    if (password.isEmpty) {
      return PasswordStatus.passwordEmpty;
    } else if (password.length < minLength) {
      return PasswordStatus.passwordShort;
    } else if (password.length > maxLength) {
      return PasswordStatus.passwordLong;
    } else if (!isPasswordValid(password)) {
      return PasswordStatus.passwordInvalid;
    }
    return PasswordStatus.passwordValid;
  }

  static bool isPasswordValid(String password) {
    // 패스워드 유효성 검사 로직 (특수문자 포함 등)
    if (password.isEmpty) {
      return false;
    } else if (password.length < minLength) {
      return false;
    } else if (password.length > maxLength) {
      return false;
    } else if (!RegExp(
            r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,20}$')
        .hasMatch(password)) {
      return false;
    }
    return true;
  }

  UserPasswordModel togglePasswordVisibility() {
    return copyWith(isPasswordVisible: !isPasswordVisible);
  }

  UserPasswordModel updatePassword(String newPassword) {
    return copyWith(password: newPassword);
  }

  static UserPasswordModel initial() {
    return UserPasswordModel(
      userPassword: null,
      passwordError: null,
      isPasswordVisible: false,
    );
  }
}
