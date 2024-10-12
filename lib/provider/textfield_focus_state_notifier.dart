import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textfieldFocusStateProvider = StateNotifierProvider.family
    .autoDispose<TextfieldFocusStateNotifier, List<FocusNode>, int>(
  (ref, count) {
    return TextfieldFocusStateNotifier(count);
  },
);

/// ### TextfieldFocusStateNotifier
///
/// - [List]<[FocusNode]> 포커스 노드 상태를 관리하는 StateNotifier
///
/// #### Fields
///
/// - [List]<[FocusNode]> state: 포커스 노드 상태
/// - [int] index: 현재 포커스 노드 인덱스
///
/// #### Methods
///
/// - [void] [setFocusNode] ([int] index): 포커스 노드 설정 메서드
/// - [void] [disposeFocusNode] ([int] index): 포커스 노드 해제 메서드
/// - [void] [clearFocus] (): 모든 포커스 노드 해제 메서드
/// - [void] [updateIndex] ([int] index): 포커스 노드 인덱스 업데이트 메서드
/// - [void] [dispose] (): 포커스 노드 해제 메서드
/// - [List]<[FocusNode]> get [getFocusNode] : 포커스 노드 반환 메서드
///
class TextfieldFocusStateNotifier extends StateNotifier<List<FocusNode>> {
  int index = 0;
  TextfieldFocusStateNotifier(length) : super([]) {
    makeFocusNode(length);
    setFocusNode(index);
  }

  void makeFocusNode(int length) {
    state = List.generate(length, (index) => FocusNode());
  }

  void expandFocusNode(int length) {
    state = [
      ...state,
      ...List.generate(length, (index) => FocusNode()),
    ];
  }

  void setFocusNode(int index) {
    state[index].requestFocus();
    updateIndex(index);
  }

  void disposeFocusNode(int index) {
    state[index].dispose();
  }

  void clearFocus() {
    for (var element in state) {
      element.unfocus();
    }
  }

  void updateIndex(int index) {
    this.index = index;
  }

  @override
  void dispose() {
    for (var element in state) {
      element.dispose();
    }
    super.dispose();
  }

  List<FocusNode> get getFocusNode => state;
}

/// ### TextfieldFocusAction
///
/// - [TextfieldFocusStateNotifier] 포커스 노드 상태를 관리하는 StateNotifier에 대한 확장 메서드
///
/// #### Methods
///
/// - [void] [nextFocusNodeMethod] (): 다음 포커스 노드 설정 메서드
///
extension TextfieldFocusAction on TextfieldFocusStateNotifier {
  void nextFocusNodeMethod() {
    if (index < getFocusNode.length - 1) {
      setFocusNode(index + 1);
    }
  }
}
