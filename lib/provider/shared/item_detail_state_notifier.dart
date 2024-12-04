import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/item/item_model.dart';

import 'package:woju/service/api/http_service.dart';

/// # [ItemDetailModel]
/// - 아이템 상세 정보를 관리하는 클래스
///
/// ### Fields
/// - [ItemDetailModel] - [item] : 아이템 UUID
/// - [bool]? - [isLoading] : 아이템 정보를 받아오는 중인지 여부, null인 경우 first loading
///
/// ### Methods
/// - [ItemDetailModel] - [copyWith] : 상태를 복사하여 새로운 상태를 반환한다.
/// - [bool] - [isMyItem] : 아이템이 내 아이템인지 여부를 반환한다.
///
class ItemDetailState {
  final ItemDetailModel item;
  final bool? isLoading;

  ItemDetailState({
    required this.item,
    required this.isLoading,
  });

  factory ItemDetailState.initial() {
    return ItemDetailState(
      item: ItemDetailModel.initial(),
      isLoading: null,
    );
  }

  /// # [copyWith]
  /// - 상태를 복사하여 새로운 상태를 반환한다.
  ///
  /// ### Parameters
  /// - [ItemDetailModel]? - [item] : 아이템 상세 정보
  /// - [bool]? - [isLoading] : 아이템 정보를 받아오는 중인지 여부
  ///
  /// ### Returns
  /// - [ItemDetailState] : 새로운 상태
  ///
  ItemDetailState copyWith({
    ItemDetailModel? item,
    bool? isLoading,
    bool? setToNullIsLoading,
  }) {
    return ItemDetailState(
      item: item ?? this.item,
      isLoading:
          setToNullIsLoading == true ? null : isLoading ?? this.isLoading,
    );
  }

  /// # [isMyItem]
  /// - 아이템이 내 아이템인지 여부를 반환한다.
  ///
  /// ### Parameters
  /// - [String] - [userUUID] : 사용자 UUID
  ///
  /// ### Returns
  /// - [bool] : 내 아이템 여부
  ///
  bool isMyItem(String userUUID) {
    return item.itemOwnerUUID == userUUID;
  }
}

final itemDetailStateProvider =
    StateNotifierProvider.autoDispose<ItemDetailStateNotifier, ItemDetailState>(
  (ref) => ItemDetailStateNotifier(),
);

/// # [ItemDetailStateNotifier]
/// - 아이템 상세 페이지의 상태를 관리하는 클래스
///
/// ### Methods
/// - [ItemDetailStateNotifier] - [ItemDetailStateNotifier] : 생성자
/// - [void] - [updateItemDetail] : 아이템 상세 정보를 업데이트한다.
/// - [void] - [updateLoading] : 로딩 상태를 업데이트한다.
/// - [void] - [clearItemDetail] : 아이템 상세 정보를 초기화한다.
///
class ItemDetailStateNotifier extends StateNotifier<ItemDetailState> {
  ItemDetailStateNotifier() : super(ItemDetailState.initial());

  void updateItemDetail(ItemDetailModel item) {
    state = state.copyWith(item: item);
  }

  void updateLoading(bool? isLoading) {
    state = state.copyWith(
        isLoading: isLoading, setToNullIsLoading: isLoading == null);
  }

  void clearItemDetail() {
    state = ItemDetailState.initial();
  }

  ItemDetailState get getState => state;
}

/// # [ItemDetailPageAction]
/// - 아이템 상세 페이지 액션
///
/// ### Methods
/// - [ItemDetailPageAction] - [fetchItemDetail] : 아이템 상세 정보를 받아온다.
/// - [void] - [pushItemEditPage] : 아이템 수정 페이지로 이동한다.
///
extension ItemDetailPageAction on ItemDetailStateNotifier {
  /// # [fetchItemDetail]
  /// - 아이템 상세 정보를 받아온다.
  ///
  /// ### Parameters
  /// - [String]? - [itemUUID] : 아이템 UUID
  /// - [String]? - [userToken] : 사용자 토큰
  /// - [bool] - [forceRefresh] : 강제로 받아올지 여부
  ///
  /// ### Returns
  /// - [Future]<[ItemDetailModel]>? : 아이템 상세 정보 (null일 경우 null 반환)
  ///
  Future<ItemDetailModel?> fetchItemDetail(
      String? itemUUID, String? userToken, bool forceRefresh) async {
    if (getState.item.itemUUID == itemUUID && !forceRefresh) {
      return getState.item;
    }

    updateLoading(true);

    if (itemUUID == null || userToken == null) {
      return null;
    }

    final json = {
      'itemUUID': itemUUID,
    };

    final response = await HttpService.itemGet(
      '/item/get-item-info',
      header: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      query: json,
    );

    if (response.statusCode != 200) {
      updateLoading(false);
      return null;
    }

    final itemDetail =
        ItemDetailModel.fromJson(jsonDecode(response.body)['item']);

    updateItemDetail(itemDetail);
    updateLoading(false);

    return itemDetail;
  }

  /// # [pushItemEditPage]
  /// - 아이템 수정 페이지로 이동한다.
  ///
  void pushItemEditPage(BuildContext context, {ItemDetailModel? item}) {
    if (item != null) {
      updateItemDetail(item);
    } else {
      item = getState.item;
    }
    context.push('/addItem', extra: item);
  }
}
