import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:woju/model/item/add_item_state_model.dart';
import 'package:woju/model/item/item_model.dart';
import 'package:woju/model/item/category_model.dart' as woju;

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
    final result =
        await HttpService.itemGet('/item/get-users-item-list', header: {
      'Authorization': 'Bearer $userToken',
    });

    if (result.statusCode == 200) {
      // 받아온 데이터를 itemList에 저장한다.
      final jsonDecodeResponse = jsonDecode(result.body);

      final itemListJson = jsonDecodeResponse['itemList'];

      if (itemListJson == null) {
        return [];
      }

      final itemList = (itemListJson as List).map((e) {
        var result = ItemDetailModel.fromJson(e);
        return result;
      }).toList();
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

  /// ### [getItemListWithQuery]
  /// - 쿼리를 이용하여 아이템 목록을 받아온다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [Int?] - [limit] : 받아올 아이템 개수
  /// - [Int?] - [page] : 페이지
  /// - [Int?] - [sort] : 정렬 방식
  /// - [String?] - [search] : 검색어
  /// - [List<Category>?] - [categoryList] : 카테고리 리스트
  /// - [Int?] - [priceMin] : 최소 가격
  /// - [Int?] - [priceMax] : 최대 가격
  /// - [Int?] - [feelingOfUseMin] : 상품 상태 최소값
  /// - [Int?] - [status] : 상품 등록 상태
  ///
  /// #### Returns
  /// - [Future]<[List]<[ItemDetailModel]>> - 아이템 목록
  ///
  static Future<List<ItemDetailModel>> getItemListWithQuery(
    String userToken, {
    int? limit,
    int? page,
    int? sort,
    String? search,
    List<woju.Category>? categoryList,
    Map<woju.Category, int>? categoryMap,
    int? priceMin,
    int? priceMax,
    int? feelingOfUseMin,
    int? status,
  }) async {
    final result = await HttpService.itemGet(
      '/item/get-item-list-with-query',
      header: {
        'Authorization': 'Bearer $userToken',
      },
      query: {
        'limit': limit?.toString(),
        'page': page?.toString(),
        'sort': sort?.toString(),
        'search': search,
        'categoryList': categoryList?.map((e) => e.index).join(','),
        'categoryMap': categoryMap
            ?.map((key, value) => MapEntry(key.name, value))
            .toString(),
        'priceMin': priceMin,
        'priceMax': priceMax,
        'feelingOfUseMin': feelingOfUseMin?.toString(),
        'status': status?.toString(),
      },
    );

    if (result.statusCode == 200) {
      final jsonDecodeResponse = jsonDecode(result.body);
      printd("jsonDecodeResponse: $jsonDecodeResponse");

      final itemListJson = jsonDecodeResponse['itemList'];

      if (itemListJson == null) {
        return [];
      }

      final itemList = (itemListJson as List).map((e) {
        var result = ItemDetailModel.fromJson(e);
        return result;
      }).toList();
      return itemList;
    }
    printd("error: ${result.body}");
    return [];
  }

  /// ### [requestItemLikeOrUnlike]
  /// - 아이템 좋아요를 요청한다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [String] - [myItemUUID] : 아이템 UUID
  /// - [String] - [targetItemUUID] : 좋아요할 아이템 UUID
  /// - [bool] - [isLike] : 좋아요인지 아닌지
  ///
  /// #### Returns
  /// - [Future]<[Bool]> - 성공 여부
  ///
  static Future<bool> requestItemLikeOrUnlike(
    String userToken,
    String? myItemUUID,
    String targetItemUUID,
    bool isLike,
  ) async {
    http.Response response;

    if (isLike) {
      if (myItemUUID == null) {
        // like 요청은 myItemUUID가 필수이다.
        return false;
      }
      final json = {
        'myItemUUID': myItemUUID,
        'targetItemUUID': targetItemUUID,
        'isLike': isLike,
      };
      response = await HttpService.itemPost(
        '/item/request-like-item',
        json,
        header: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );
    } else {
      final unlikeJson = {
        'targetItemUUID': targetItemUUID,
      };
      response = await HttpService.itemPost(
        '/item/request-unlike-item',
        unlikeJson,
        header: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      printd("requestItemLikeOrUnlike error: ${response.body}");
      return false;
    }
  }

  /// ### [requestItemMatch]
  /// - 아이템 매칭을 요청한다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  /// - [String] - [myItemUUID] : 나의 아이템 UUID
  /// - [String] - [targetItemUUID] : 매칭할 아이템 UUID
  ///
  /// #### Returns
  /// - [Future]<[Bool]> - 성공 여부
  ///
  static Future<bool> requestItemMatch(
    String userToken,
    String myItemUUID,
    String targetItemUUID,
  ) async {
    final json = {
      'myItemUUID': myItemUUID,
      'targetItemUUID': targetItemUUID,
    };

    final response = await HttpService.itemPost(
      '/item/request-match-item',
      json,
      header: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      printd("requestItemMatch error: ${response.statusCode}");
      printd("requestItemMatch error: ${response.body}");
      return false;
    }
  }
}
