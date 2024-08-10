import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/hive_box_enum.dart';

import '../model/app_state_model.dart';

/// ### 온보딩 상태를 관리하는 StateNotifier
///
/// Hive를 사용하여 온보딩 상태를 저장하고 업데이트합니다.
///
final onboardingStateProvider =
    StateNotifierProvider<OnboardingStateNotifier, OnboardingState>(
  (ref) {
    final box = Hive.box<OnboardingState>(HiveBox.onboardingStateBox.name);
    return OnboardingStateNotifier(box);
  },
);

class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  final Box<OnboardingState> _box;

  // 초기 상태를 불러오거나 기본값을 설정
  OnboardingStateNotifier(this._box) : super(OnboardingState.initialState) {
    read();
  }

  /// ### 온보딩 상태를 업데이트
  ///
  /// box에 onboardingState를 저장하고 상태를 업데이트합니다.
  ///
  /// ```dart
  /// ref.read(onboardingStateProvider.notifier).update(newState);
  /// ```
  void update(OnboardingState newState) async {
    await _box.put(HiveBox.onboardingStateBox.name, newState);
    state = newState;
  }

  /// ### 온보딩 상태를 초기화
  ///
  /// box에서 onboardingState를 삭제하고 상태를 초기화합니다.
  void delete() async {
    await _box.delete(HiveBox.onboardingStateBox.name);
    state = OnboardingState.initialState;
  }

  /// ### box 값을 불러옵니다.
  ///
  /// box에서 onboardingState를 불러옵니다.
  ///
  Future<OnboardingState> read() async {
    await Hive.openBox<OnboardingState>(HiveBox.onboardingStateBox.name);
    state = _box.get(HiveBox.onboardingStateBox.name,
            defaultValue: OnboardingState.initialState) ??
        OnboardingState.initialState;

    return state;
  }
}

/// OnboardingStateNotifier를 위한 Action을 정의한 확장
///
extension OnboardingAction on OnboardingState {}
