import 'package:flutter_riverpod/flutter_riverpod.dart';

/// # BottomBarStateNotifier
///
/// - 홈 화면의 하단 바 상태를 관리하는 프로바이더입니다.
///
final bottomBarStateProvider =
    StateNotifierProvider<BottomBarStateNotifier, int>(
  (ref) => BottomBarStateNotifier(),
);

/// # BottomBarStateNotifier
///
/// - 하단 바의 인덱스를 관리합니다.
///
/// ### Methods
///
/// - [void] [setIndex] ([int] index): 하단 바의 인덱스를 설정합니다.
/// - [int] get [index]: 하단 바의 인덱스를 반환합니다.
///
class BottomBarStateNotifier extends StateNotifier<int> {
  BottomBarStateNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }

  int get index => state;
}
