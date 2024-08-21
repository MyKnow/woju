import 'package:hive_flutter/hive_flutter.dart';

part 'user_gender_model.g.dart';

@HiveType(typeId: 2)
enum Gender {
  @HiveField(0)
  private,

  @HiveField(1)
  man,

  @HiveField(2)
  woman,

  @HiveField(3)
  other,
}

extension GenderExtension on Gender {
  // 해당 enum의 이름을 문자열로 반환
  String get toMessage {
    return "status.gender.${toString().split('.').last}";
  }

  // 해당 enum의 이름을 문자열로 반환
  String get value {
    return toString().split('.').last;
  }

  static Gender getGenderFromString(String value) {
    switch (value) {
      case "private":
        return Gender.private;
      case "man":
        return Gender.man;
      case "woman":
        return Gender.woman;
      case "other":
        return Gender.other;
      default:
        return Gender.private;
    }
  }
}