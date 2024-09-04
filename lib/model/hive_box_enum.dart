import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/setting/setting.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/model/user/user_gender_model.dart';

enum HiveBox {
  userDetailInfoBox,
  genderBox,
  settingBox,
}

extension HiveBoxExt on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.userDetailInfoBox:
        return 'userDetailInfoBox';
      case HiveBox.genderBox:
        return 'genderBox';
      case HiveBox.settingBox:
        return 'settingBox';
    }
  }

  // Adapter를 등록하는 메서드
  void registerAdapter() {
    switch (this) {
      case HiveBox.userDetailInfoBox:
        Hive.registerAdapter(UserDetailInfoModelAdapter());
        break;
      case HiveBox.genderBox:
        Hive.registerAdapter(GenderAdapter());
        break;
      case HiveBox.settingBox:
        Hive.registerAdapter(SettingModelAdapter());
        break;
    }
  }

  // Box를 열어주는 메서드
  Future<void> openBox() async {
    switch (this) {
      case HiveBox.userDetailInfoBox:
        await Hive.openBox<UserDetailInfoModel>(name);
        break;
      case HiveBox.genderBox:
        await Hive.openBox<Gender>(name);
        break;
      case HiveBox.settingBox:
        await Hive.openBox<SettingModel>(name);
        break;
    }
  }
}
