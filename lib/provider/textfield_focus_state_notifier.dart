import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textfieldFocusStateProvider = StateNotifierProvider.family
    .autoDispose<TextfieldFocusStateNotifier, List<FocusNode>, int>(
  (ref, count) {
    return TextfieldFocusStateNotifier(count);
  },
);

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

extension TextfieldFocusAction on TextfieldFocusStateNotifier {
  void nextFocusNode() {
    if (index < getFocusNode.length - 1) {
      setFocusNode(index + 1);
    }
  }
}
