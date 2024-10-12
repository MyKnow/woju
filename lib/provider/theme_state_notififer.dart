import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/setting/setting_state_notifier.dart';
import 'package:woju/service/debug_service.dart';

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotififer, ThemeMode>(
  (ref) => ThemeStateNotififer(ref),
);

/// ### ThemeStateNotififer
///
/// - [ThemeMode] 테마 상태를 관리하는 StateNotifier
///
/// #### Fields
///
/// - [ThemeMode] state: 테마 상태
/// - [Ref] ref: Ref
///
/// #### Methods
///
/// - [void] [updateTheme] ([int] index): 테마 업데이트 메서드
/// - [int] [getIndex] (): 테마 인덱스 반환 메서드
/// - [void] [readFromDB] (): DB에서 테마 읽어오는 메서드
///
class ThemeStateNotififer extends StateNotifier<ThemeMode> {
  late Ref ref;
  ThemeStateNotififer(this.ref) : super(ThemeMode.system) {
    readFromDB();
  }

  void updateTheme(int index) async {
    if (index == 0) {
      state = ThemeMode.system;
    } else if (index == 1) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
    await ref.read(settingStateProvider.notifier).update(
          ref.read(settingStateProvider).copyWith(themeIndex: index),
        );
  }

  int getIndex() {
    if (state == ThemeMode.system) {
      return 0;
    } else if (state == ThemeMode.light) {
      return 1;
    } else {
      return 2;
    }
  }

  void readFromDB() {
    final setting = ref.read(settingStateProvider);
    printd("Setting: ${setting.themeIndex}");
    updateTheme(setting.themeIndex);
  }
}
