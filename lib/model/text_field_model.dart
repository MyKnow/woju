import 'package:easy_localization/easy_localization.dart';

mixin TextFieldModel<T> {
  // 필수적으로 구현해야 하는 메서드들
  T? get value;
  bool get isValid;

  // 라벨 반환 (경우에 따라 파라미터를 받을 수 있음)
  String get labelText {
    return "input.defaultLabel".tr();
  }

  // 에러 메시지 반환
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return "input.defaultError".tr();
    }
  }

  String? Function(dynamic)? get validator {
    return (value) {
      if (isValid) {
        return null;
      } else {
        return errorMessage;
      }
    };
  }
}
