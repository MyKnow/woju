import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/hive_box_enum.dart';
import 'package:woju/model/setting/setting.dart';

/// ### 환경 설정을 관리하는 StateNotifier
///
/// Hive를 사용하여 환경 설정의 상태를 저장하고 업데이트합니다.
///
final settingStateProvider =
    StateNotifierProvider<SettingStateNotifier, SettingModel>(
  (ref) {
    final box = Hive.box<SettingModel>(HiveBox.settingBox.name);
    return SettingStateNotifier(box);
  },
);

class SettingStateNotifier extends StateNotifier<SettingModel> {
  final Box<SettingModel> _box;
  final String _boxName = HiveBox.settingBox.name;

  // 초기 상태를 불러오거나 기본값을 설정
  SettingStateNotifier(this._box) : super(SettingModel.initialState) {
    read();
  }

  /// ### 유저 세부 정보 상태를 업데이트
  ///
  /// box에 settingStateProvider를 저장하고 상태를 업데이트합니다.
  ///
  Future<void> update(SettingModel newState) async {
    await _box.put(_boxName, newState);
    state = newState;
  }

  /// ### 유저 세부 정보 상태를 초기화
  ///
  /// box에서 settingStateProvider를 삭제하고 상태를 초기화합니다.
  ///
  Future<void> delete() async {
    await _box.delete(_boxName);
    state = SettingModel.initialState;
  }

  /// ### box 값을 불러옵니다.
  ///
  /// box에서 settingStateProvider를 불러옵니다.
  ///
  Future<SettingModel> read() async {
    state = _box.get(_boxName, defaultValue: SettingModel.initialState) ??
        SettingModel.initialState;

    return state;
  }

  /// ### SettingStateProvider 반환
  ///
  /// 현재 SettingStateProvider를 반환합니다.
  ///
  /// #### Return
  ///
  /// - [SettingModel] : 현재 SettingModel
  ///
  SettingModel get settingState => state;
}
