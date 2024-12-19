import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/item_model.dart';

import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';

import 'package:woju/service/api/item_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/toast_message_service.dart';

class MatchPageState {
  final ItemDetailModel? selectedItem;
  final List<ItemDetailModel> myItems;
  final List<ItemDetailModel> recommendedItems;
  final String userToken;
  final bool isLoading;
  final String errorMessage;
  final double? firstDx;
  final bool? isSwipeToLike;

  MatchPageState({
    required this.selectedItem,
    required this.myItems,
    required this.recommendedItems,
    required this.userToken,
    required this.isLoading,
    required this.errorMessage,
    this.firstDx,
    this.isSwipeToLike,
  });

  MatchPageState copyWith({
    ItemDetailModel? selectedItem,
    List<ItemDetailModel>? myItems,
    List<ItemDetailModel>? recommendedItems,
    bool? isLoading,
    String? userToken,
    bool? hasError,
    String? errorMessage,
    double? firstDx,
    bool? setToNullFirstDx,
    bool? isSwipeToLike,
    bool? setToNullIsSwipeToLike,
  }) {
    return MatchPageState(
      selectedItem: selectedItem ?? this.selectedItem,
      myItems: myItems ?? this.myItems,
      recommendedItems: recommendedItems ?? this.recommendedItems,
      userToken: userToken ?? this.userToken,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      firstDx: setToNullFirstDx == true ? null : firstDx ?? this.firstDx,
      isSwipeToLike: setToNullIsSwipeToLike == true
          ? null
          : isSwipeToLike ?? this.isSwipeToLike,
    );
  }

  static MatchPageState initial() {
    return MatchPageState(
      selectedItem: null,
      myItems: [],
      recommendedItems: [],
      userToken: "",
      isLoading: false,
      errorMessage: "",
      firstDx: null,
      isSwipeToLike: null,
    );
  }
}

final matchPageStateProvider =
    StateNotifierProvider.autoDispose<MatchPageStateNotifier, MatchPageState>(
  (ref) {
    return MatchPageStateNotifier(ref);
  },
);

class MatchPageStateNotifier extends StateNotifier<MatchPageState> {
  late Ref ref;
  MatchPageStateNotifier(this.ref) : super(MatchPageState.initial());

  void setIsSwipeToLike(bool? isSwipeToLike) {
    state = state.copyWith(
      isSwipeToLike: isSwipeToLike,
      setToNullIsSwipeToLike: isSwipeToLike == null,
    );
  }

  void setFirstDx(double? dx) {
    state = state.copyWith(
      firstDx: dx,
      setToNullFirstDx: dx == null,
    );
  }

  Future<void> fetchMyItems() async {
    final myUserToken = ref.read(userDetailInfoStateProvider)?.userToken ?? "";
    state = state.copyWith(isLoading: true);
    final myItems = await ItemService.fetchItemList(myUserToken);
    printd("myItems: $myItems");

    // myItems이 존재하는 경우에만 추천 아이템을 받아온다.
    if (myItems.isEmpty) {
      state = state.copyWith(myItems: myItems, isLoading: false);
      return;
    } else {
      final recommendedItems =
          await ItemService.getItemListWithQuery(myUserToken);
      printd("recommendedItems: $recommendedItems");

      state = state.copyWith(
        myItems: myItems,
        recommendedItems: recommendedItems,
        selectedItem: (myItems.length == 1) ? myItems.first : null,
        userToken: myUserToken,
        isLoading: false,
      );
    }
  }

  void selectItem(ItemDetailModel item) {
    state = state.copyWith(selectedItem: item);
  }

  void deleteRecommendedItem(String itemUUID) {
    final recommends = state.recommendedItems;
    final newRecommends =
        recommends.where((item) => item.itemUUID != itemUUID).toList();
    state = state.copyWith(recommendedItems: newRecommends);
  }

  MatchPageState get getState => state;
}

extension MatchPageStateNotifierExtension on MatchPageStateNotifier {
  void onDragUpdateChange(DragUpdateDetails details) {
    if (getState.firstDx == null) {
      setFirstDx(details.localPosition.dx);
    } else {
      bool? isSwipeToLike;

      if ((details.localPosition.dx - getState.firstDx!).abs() < 100) {
        isSwipeToLike = null;
      } else if (details.localPosition.dx - getState.firstDx! > 0) {
        isSwipeToLike = true;
      } else {
        isSwipeToLike = false;
      }
      printd("isSwipeToLike: $isSwipeToLike");
      setIsSwipeToLike(isSwipeToLike);
    }
  }

  void onDragEndRequest(BuildContext context, String targetItemUUID) async {
    final isSwipeToLike = getState.isSwipeToLike;
    printd("isSwipeToLike: $isSwipeToLike");

    // 스와이프를 진행한 경우 아이템 UnLike 요청
    final userToken = getState.userToken;
    if (isSwipeToLike == false) {
      final result = await ItemService.requestItemLikeOrUnlike(
          userToken, null, targetItemUUID, false);

      if (result) {
        printd("unlike success");
        deleteRecommendedItem(targetItemUUID);
        setFirstDx(null);
        setIsSwipeToLike(false);
      } else {
        printd("unlike fail");
        setFirstDx(null);
        setIsSwipeToLike(false);
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "matchPage.snackbar.unlikeFailure", context);
        }
      }
    } else if (isSwipeToLike == true) {
      final myItemUUID = getState.selectedItem?.itemUUID;

      if (myItemUUID == null) {
        printd("myItemUUID is null");
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "matchPage.snackbar.likeFailure", context);
        }
        return;
      }

      final result = await ItemService.requestItemLikeOrUnlike(
          userToken, myItemUUID, targetItemUUID, true);

      if (result) {
        printd("like success");
        deleteRecommendedItem(targetItemUUID);
        setFirstDx(null);
        setIsSwipeToLike(true);
      } else {
        printd("like fail");
        setFirstDx(null);
        setIsSwipeToLike(true);
        if (context.mounted) {
          ToastMessageService.nativeSnackbar(
              "matchPage.snackbar.likeFailure", context);
        }
      }

      // 만약 targetItemUUID가 selectedItem의 itemLikedUsers(Map<userUUID, itemUUID>)에 존재한다면, 매칭하고, 아니라면 좋아요 요청
      final selectedItem = getState.selectedItem;

      final isMatched = selectedItem?.itemLikedUsers.entries
          .any((element) => element.value == targetItemUUID);

      if (isMatched == true) {
        final result = await ItemService.requestItemMatch(
            userToken, myItemUUID, targetItemUUID);

        if (result) {
          printd("match success");
          deleteRecommendedItem(targetItemUUID);
          setFirstDx(null);
          setIsSwipeToLike(true);
        } else {
          printd("match fail");
          setFirstDx(null);
          setIsSwipeToLike(true);
          if (context.mounted) {
            ToastMessageService.nativeSnackbar(
                "matchPage.snackbar.matchFailure", context);
          }
        }
        return;
      }
    } else {
      // 스와이프를 하지 않은 경우
      setFirstDx(null);
      setIsSwipeToLike(null);
    }
  }
}
