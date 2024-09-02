import 'package:flutter/services.dart';
import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';

enum PasswordStatus with StatusMixin {
  empty,
  short,
  long,
  invalid,
  valid,
  validForSignIn,
}

class UserPasswordModel with TextFieldModel {
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
    }
    // 특수문자가 포함되어야 함
    else if (!RegExp("""[!@#\$%^&*()-_=+{}[]|;:"<>,./?`~'\\₩]""")
        .hasMatch(password)) {
      return false;
    }
    // 영문이 포함되어야 함
    else if (!RegExp("""[a-zA-Z]""").hasMatch(password)) {
      return false;
    }
    // 숫자가 포함되어야 함
    else if (!RegExp("""[0-9]""").hasMatch(password)) {
      return false;
    }

    return true;
  }

  static UserPasswordModel initial() {
    return UserPasswordModel(
      userPassword: null,
      passwordError: null,
      isPasswordVisible: false,
    );
  }

  @override
  bool get isValid => validatePassword(userPassword) == PasswordStatus.valid;

  @override
  get value => userPassword;

  @override
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return validatePassword(userPassword).toMessage;
    }
  }

  @override
  String get labelText {
    if (isPasswordAvailable) {
      return PasswordStatus.valid.toMessage;
    } else {
      return PasswordStatus.empty.toMessage;
    }
  }

  String labelTextWithParameter(bool isSignUp) {
    if (isPasswordAvailable) {
      if (isSignUp) {
        return PasswordStatus.valid.toMessage;
      } else {
        return PasswordStatus.validForSignIn.toMessage;
      }
    } else {
      return PasswordStatus.empty.toMessage;
    }
  }

  List<TextInputFormatter>? get getInputFormatter {
    return [
      FilteringTextInputFormatter.allow(
        RegExp("""[a-zA-Z0-9!@#\$%^&*()-_=+{}[]|;:"<>,./?~'\\₩]"""),
      ),
      LengthLimitingTextInputFormatter(20),
    ];
  }
}
