import 'package:easy_localization/easy_localization.dart';

mixin StatusMixin {
  String get toMessage {
    return "status.$this".tr();
  }
}
