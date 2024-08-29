import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';

enum UserNickNameStatus with StatusMixin {
  valid,
  invalid,
  empty,
  short,
  long,
  validForDisabled,
}

class UserNicknameModel with TextFieldModel<String> {
  final String? nickname;
  final bool isNicknameValid;
  final bool isEditing;

  UserNicknameModel({
    required this.nickname,
    this.isEditing = false,
  }) : isNicknameValid =
            nickNameValidator(nickname) == UserNickNameStatus.valid;

  UserNicknameModel copyWith({
    String? nickname,
    bool? isEditing,
  }) {
    return UserNicknameModel(
      nickname: nickname ?? this.nickname,
      isEditing: isEditing ?? this.isEditing,
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
      nickname: null,
      isEditing: false,
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

  String? get labelTextForEditing {
    if (isValid) {
      if (isEditing) {
        return UserNickNameStatus.valid.toMessage;
      } else {
        return UserNickNameStatus.validForDisabled.toMessage;
      }
    } else {
      return UserNickNameStatus.empty.toMessage;
    }
  }

  @override
  String? get value {
    return nickname;
  }
}
