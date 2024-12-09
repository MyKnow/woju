import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:woju/model/item/add_item_state_model.dart';
import 'package:woju/model/item/item_model.dart';

import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/debug_service.dart';

/// # [ItemService]
/// - 상품 관련 API를 관리하는 클래스
///
/// ### Methods
/// - [Future]<[http.Response]> - [fetchItemList] : 아이템 목록을 받아온다.
/// - [Future><[http.Response]> - [addItem] : 아이템을 등록한다.
///
class ItemService {
  /// ### [fetchItemList]
  /// - 아이템 목록을 받아온다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  ///
  /// #### Returns
  /// - [Future]<[http.Response]>
  ///
  static Future<List<ItemDetailModel>> fetchItemList(String userToken) async {
    final result = await HttpService.itemGet('/item/get-item-list', header: {
      'Authorization': 'Bearer $userToken',
    });

    if (result.statusCode == 200) {
      // 받아온 데이터를 itemList에 저장한다.
      final jsonDecodeResponse = jsonDecode(result.body);

      final itemListJson = jsonDecodeResponse['itemList'];

      if (itemListJson == null) {
        return [];
      }

      final itemList = (itemListJson as List)
          .map((e) => ItemDetailModel.fromJson(e))
          .toList();

      return itemList;
    }
    return [];
  }

  /// ### [addItem]
  /// - 아이템을 등록한다.
  ///
  /// #### Parameters
  /// - [AddItemStateModel] - [addItemModel] : 아이템 정보
  /// - [String] - [userToken] : 사용자 토큰
  ///
  /// #### Returns
  /// - [Future]<[http.Response]>
  ///
  static Future<http.Response> addItem(
    AddItemStateModel addItemModel,
    String userToken,
  ) async {
    return await HttpService.itemPost(
      '/item/add-item',
      addItemModel.toJson(),
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );
  }

  /// ### [deleteItem]
  /// - 아이템을 삭제한다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [String] - [itemUUID] : 삭제할 아이템 UUID
  ///
  /// #### Returns
  /// - [Future]<[http.Response]>
  ///
  static Future<http.Response> deleteItem(
      String userToken, String itemUUID) async {
    return await HttpService.itemDelete(
      '/item/delete-item',
      {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      body: {
        'itemUUID': itemUUID,
      },
    );
  }

  /// ### [updateItem]
  /// - 아이템을 업데이트한다.
  ///
  /// #### Parameters
  /// - [AddItemStateModel] - [addItemModel] : 아이템 정보
  /// - [String] - [userToken] : 사용자 토큰
  ///
  /// #### Returns
  /// - [Future]<[http.Response]>
  ///
  static Future<http.Response> updateItem(
    ItemDetailModel? itemDetailModel,
    String userToken, {
    AddItemStateModel? addItemModel,
  }) async {
    if (itemDetailModel != null) {
      addItemModel =
          AddItemStateModel.convertFromItemDetailModel(itemDetailModel);
    }

    addItemModel ??= AddItemStateModel.initial();

    printd("addItemModel.itemUUID: ${addItemModel.itemUUID}");

    printd("json : ${addItemModel.toJson()['itemUUID']}");

    return await HttpService.itemPost(
      '/item/update-item',
      addItemModel.toJson(),
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );
  }
}
