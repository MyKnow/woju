import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/app_state_model.dart';

enum HiveBox {
  onboardingStateBox,
}

extension HiveBoxExt on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.onboardingStateBox:
        return 'onboardingStateBox';
    }
  }

  // Adapter를 등록하는 메서드
  void registerAdapter() {
    switch (this) {
      case HiveBox.onboardingStateBox:
        Hive.registerAdapter(OnboardingStateAdapter());
        break;
    }
  }

  // Box를 열어주는 메서드
  Future<void> openBox() async {
    switch (this) {
      case HiveBox.onboardingStateBox:
        await Hive.openBox<OnboardingState>(name);
        break;
    }
  }
}
