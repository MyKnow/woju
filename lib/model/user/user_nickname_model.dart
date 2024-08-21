enum UserNickNameStatus {
  valid,
  invalid,
  empty,
  short,
  long,
}

extension UserNickNameStatusExtension on UserNickNameStatus {
  String get toMessage {
    switch (this) {
      case UserNickNameStatus.valid:
        return "status.nickname.valid";
      case UserNickNameStatus.invalid:
        return "status.nickname.invalid";
      case UserNickNameStatus.empty:
        return "status.nickname.empty";
      case UserNickNameStatus.short:
        return "status.nickname.short";
      case UserNickNameStatus.long:
        return "status.nickname.long";
    }
  }
}

class UserNicknameModel {
  final String? nickname;
  final bool isNicknameValid;

  UserNicknameModel({
    required this.nickname,
  }) : isNicknameValid =
            nickNameValidator(nickname) == UserNickNameStatus.valid;

  UserNicknameModel copyWith({
    String? nickname,
  }) {
    return UserNicknameModel(
      nickname: nickname ?? this.nickname,
    );
  }

  static UserNickNameStatus nickNameValidator(String? nickname) {
    if (nickname == null || nickname.isEmpty) {
      return UserNickNameStatus.empty;
    } else if (nickname.length < 2) {
      return UserNickNameStatus.short;
    } else if (nickname.length > 20) {
      return UserNickNameStatus.long;
    } else {
      return UserNickNameStatus.valid;
    }
  }

  static UserNicknameModel initial() {
    return UserNicknameModel(
      nickname: "",
    );
  }

  String labelText() {
    return "status.nickname.title";
  }
}
