import 'package:hive_flutter/hive_flutter.dart';

part 'setting.g.dart';

@HiveType(typeId: 3)
class SettingModel {
  @HiveField(0)
  final int themeIndex;

  SettingModel({
    required this.themeIndex,
  });

  SettingModel copyWith({
    int? themeIndex,
  }) {
    return SettingModel(
      themeIndex: themeIndex ?? this.themeIndex,
    );
  }

  static SettingModel get initialState => SettingModel(themeIndex: 0);
}
