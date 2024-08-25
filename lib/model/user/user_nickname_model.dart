import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';

enum UserNickNameStatus with StatusMixin {
  valid,
  invalid,
  empty,
  short,
  long,
}

class UserNicknameModel with TextFieldModel<String> {
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

  @override
  bool get isValid => nickNameValidator(nickname) == UserNickNameStatus.valid;

  @override
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return nickNameValidator(nickname).toMessage;
    }
  }

  @override
  String get labelText {
    if (isValid) {
      return UserNickNameStatus.valid.toMessage;
    } else {
      return UserNickNameStatus.empty.toMessage;
    }
  }

  @override
  String? get value {
    return nickname;
  }
}
