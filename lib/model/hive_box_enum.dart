import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/app_state_model.dart';
import 'package:woju/model/onboarding/user_detail_info_model.dart';

enum HiveBox {
  onboardingStateBox,
  userDetailInfoBox,
}

extension HiveBoxExt on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.onboardingStateBox:
        return 'onboardingStateBox';
      case HiveBox.userDetailInfoBox:
        return 'userDetailInfoBox';
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
    }
  }
}
