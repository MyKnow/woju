enum PasswordStatus {
  empty,
  short,
  long,
  invalid,
  valid,
}

extension PasswordErrorExtension on PasswordStatus {
  String? get toMessage {
    return "status.password.${toString().split('.').last}";
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
            validatePassword(userPassword) == PasswordStatus.valid;

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
      return PasswordStatus.empty;
    }

    if (password.isEmpty) {
      return PasswordStatus.empty;
    } else if (password.length < minLength) {
      return PasswordStatus.short;
    } else if (password.length > maxLength) {
      return PasswordStatus.long;
    } else if (!isPasswordValid(password)) {
      return PasswordStatus.invalid;
    }
    return PasswordStatus.valid;
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
