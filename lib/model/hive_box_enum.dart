import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/app_state_model.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/model/user/user_gender_model.dart';

enum HiveBox {
  onboardingStateBox,
  userDetailInfoBox,
  genderBox,
}

extension HiveBoxExt on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.onboardingStateBox:
        return 'onboardingStateBox';
      case HiveBox.userDetailInfoBox:
        return 'userDetailInfoBox';
      case HiveBox.genderBox:
        return 'genderBox';
    }
  }

  // Adapter를 등록하는 메서드
  void registerAdapter() {
    switch (this) {
      case HiveBox.onboardingStateBox:
        Hive.registerAdapter(OnboardingStateAdapter());
        break;
      case HiveBox.userDetailInfoBox:
        Hive.registerAdapter(UserDetailInfoModelAdapter());
        break;
      case HiveBox.genderBox:
        Hive.registerAdapter(GenderAdapter());
    }
  }

  // Box를 열어주는 메서드
  Future<void> openBox() async {
    switch (this) {
      case HiveBox.onboardingStateBox:
        await Hive.openBox<OnboardingState>(name);
        break;
      case HiveBox.userDetailInfoBox:
        await Hive.openBox<UserDetailInfoModel>(name);
        break;
      case HiveBox.genderBox:
        await Hive.openBox<Gender>(name);
    }
  }
}
