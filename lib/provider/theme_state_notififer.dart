import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/theme/custom_theme_data.dart';

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotififer, ThemeMode>(
  (ref) => ThemeStateNotififer(),
);

class ThemeStateNotififer extends StateNotifier<ThemeMode> {
  ThemeStateNotififer() : super(ThemeMode.system);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData get theme {
    if (isDark) {
      return CustomThemeData.dark;
    }
    return CustomThemeData.light;
  }

  bool get isDark =>
      WidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .platformBrightness ==
      Brightness.dark;
}
