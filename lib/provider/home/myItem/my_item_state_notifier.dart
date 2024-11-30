import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/item_model.dart';

import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/debug_service.dart';

final myItemStateProvider =
    StateNotifierProvider.autoDispose<MyItemStateNotifier, MyItemState>(
  (ref) => MyItemStateNotifier(),
);

/// # [MyItemState]
/// - 내 아이템 목록 페이지의 상태를 관리하는 클래스
///
/// ### Fields
/// - [List]<[ItemDetailModel]> - [itemList] : 아이템 전체 목록
/// - [int]? - [filter] : 필터
/// - [bool] - [isFetching] : 아이템 목록을 받아오는 중인지 여부
/// - [bool] - [isDeleting] : 아이템을 삭제하는 중인지 여부
///
/// ### Methods
/// - [MyItemState] - [copyWith] : 상태를 복사하여 새로운 상태를 반환한다.
/// - [List]<[ItemDetailModel]> - [getFilteredItemList] : 아이템 목록을 필터링하여 반환한다.
/// - [String] - [filterStatusToString] : 필터 상태를 문자열로 변환하여 반환한다.
///
class MyItemState {
  final List<ItemDetailModel> itemList;
  final int? filter;
  final bool isFetching;
  final bool isDeleting;

  const MyItemState({
    this.itemList = const [],
    this.filter,
    this.isFetching = false,
    this.isDeleting = false,
  });

  /// # [copyWith]
  /// - 상태를 복사하여 새로운 상태를 반환한다.
  ///
  /// ### Parameters
  /// - [List]<[ItemDetailModel]>? - [itemList] : 아이템 목록
  /// - [int]? - [filter] : 필터
  /// - [bool]? - [setToNullFilter] : 필터를 null로 설정할지 여부
  /// - [bool]? - [isFetching] : 아이템 목록을 받아오는 중인지 여부
  /// - [bool]? - [isDeleting] : 아이템을 삭제하는 중인지 여부
  ///
  /// ### Returns
  /// - [MyItemState] : 새로운 상태
  ///
  MyItemState copyWith({
    List<ItemDetailModel>? itemList,
    int? filter,
    bool? setToNullFilter,
    bool? isFetching,
    bool? isDeleting,
  }) {
    return MyItemState(
      itemList: itemList ?? this.itemList,
      filter: setToNullFilter == true ? null : filter ?? this.filter,
      isFetching: isFetching ?? this.isFetching,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  /// # [getFilteredItemList]
  /// - 아이템 목록을 필터링하여 반환한다.
  ///
  /// ### Note
  /// - 필터의 값이 null일 경우에는 전체 아이템 목록을 반환한다.
  /// - 필터의 값이 null이 아닐 경우에는 필터링된 아이템 목록을 반환한다.
  ///
  /// ### Returns
  /// - [List]<[ItemDetailModel]> : 필터링된 아이템 목록
  ///
  List<ItemDetailModel> getFilteredItemList() {
    if (filter == null) {
      return itemList;
    }

    return itemList.where((item) => item.itemStatus == filter).toList();
  }

  /// # [filterStatusToString]
  /// - 필터 상태를 문자열로 변환하여 반환한다.
  ///
  /// ### Returns
  /// - [String] : 필터 상태 문자열 (Localized)
  ///
  String filterStatusToString() {
    switch (filter) {
      case 0:
        return "myItem.myItemList.filterStatus.no_reservation";
      case 1:
        return "myItem.myItemList.filterStatus.reserved";
      case 2:
        return "myItem.myItemList.filterStatus.completed";
      default:
        return "myItem.myItemList.filterStatus.all";
    }
  }
}

class MyItemStateNotifier extends StateNotifier<MyItemState> {
  MyItemStateNotifier() : super(const MyItemState());

  void setItemList(List<ItemDetailModel> itemList) {
    state = state.copyWith(
      itemList: itemList,
    );
  }

  void setIsFetching(bool isFetching) {
    state = state.copyWith(
      isFetching: isFetching,
    );
  }

  void setIsDeleting(bool isDeleting) {
    state = state.copyWith(
      isDeleting: isDeleting,
    );
  }

  void setFilter(int? filter) {
    if (filter == null) {
      state = state.copyWith(
        setToNullFilter: true,
      );
      return;
    }

    state = state.copyWith(
      filter: filter,
    );
  }

  MyItemState get getState => super.state;
}

/// # [MyItemPageAction]
/// - 내 아이템 목록 페이지의 액션을 관리하는 클래스
///
/// ### Methods
/// - [Future]<[List]<[ItemDetailModel]>> - [fetchItemList] : 아이템 목록을 받아온다.
/// - [Future]<[bool]> - [deleteItem] : 아이템을 삭제한다.
///
extension MyItemPageAction on MyItemStateNotifier {
  /// # [fetchItemList]
  /// - 아이템 목록을 받아온다.
  ///
  /// ### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [bool] - [forceRefresh] : 강제로 새로고침할지 여부
  ///
  Future<List<ItemDetailModel>> fetchItemList(
      String userToken, bool forceRefresh) async {
    // 이미 아이템 목록이 있고 forceRefresh가 false일 경우에는 아이템 목록을 그대로 반환한다.
    if (getState.itemList.isNotEmpty && forceRefresh == false) {
      printd("itemList is already exist");
      return getState.itemList;
    }

    setIsFetching(true);

    // 서버로부터 아이템 목록을 받아온다.
    final response = await HttpService.itemGet('/item/get-item-list', header: {
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode != 200) {
      return [];
    }

    // 받아온 데이터를 itemList에 저장한다.
    final jsonDecodeResponse = jsonDecode(response.body);

    final itemListJson = jsonDecodeResponse['itemList'];

    if (itemListJson == null) {
      setIsFetching(false);
      return [];
    }

    final itemList =
        (itemListJson as List).map((e) => ItemDetailModel.fromJson(e)).toList();

    setItemList(itemList);
    setIsFetching(false);
    return itemList;
  }

  /// # [deleteItem]
  /// - 아이템을 삭제한다.
  ///
  /// ### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [String] - [itemUUID] : 삭제할 아이템 UUID
  ///
  Future<bool> deleteItem(String userToken, String itemUUID) async {
    final json = {
      "itemUUID": itemUUID,
    };

    setIsDeleting(true);

    final response = await HttpService.itemDelete(
      '/item/delete-item',
      {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      // 아이템 목록을 다시 받아온다.
      final itemList = await fetchItemList(userToken, true);

      if (itemList.isEmpty) {
        setIsDeleting(false);
        return false;
      }
      setItemList(itemList);
      setIsDeleting(false);
      return true;
    } else {
      printd("deleteItem error: ${response.body}");
      setIsDeleting(false);
      return false;
    }
  }

  /// # [onPressedFilterButton]
  /// - 필터 버튼을 클릭했을 때의 동작
  ///
  /// ### Note
  /// - 필터가 null일 경우에는 0으로 설정
  /// - 필터에 +1을 하고, 최대치인 3 이상일 경우 null로 설정
  ///
  void onPressedFilterButton() {
    final filter = getState.filter;

    // 필터가 null일 경우에는 0으로 설정
    // 필터에 +1을 하고, 최대치인 3 이상일 경우 null로 설정
    if (filter == null) {
      setFilter(0);
    } else if (filter + 1 < 3) {
      setFilter(filter + 1);
    } else {
      setFilter(null);
    }
  }
}
