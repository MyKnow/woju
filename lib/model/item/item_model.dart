import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/model/item/location_model.dart';
import 'package:woju/service/debug_service.dart';

/// # ItemModel
///
/// - 상품 정보를 담는 모델
///
/// ### Fields
///
/// - [CategoryModel]? - [itemCategory] : 상품 카테고리 리스트
/// - [List]<[Uint8List]> - [itemImageList] : 상품 이미지 리스트
/// - [String]? - [itemName] : 상품 이름
/// - [String]? - [itemDescription] : 상품 설명
/// - [int]? - [itemPrice] : 상품 가격
/// - [double]? - [feelingOfUse] : 사용감 정보
///
/// ### Methods
///
/// - [ItemModel] -[initial] : 초기 상태 반환
/// - [int] - [countOfItemImage] : 상품 이미지 개수 반환
/// - [bool] - [isValidItemCategory] : 상품 카테고리 리스트 유효성 검사
/// - [bool] - [isValidItemImageList] : 상품 이미지 리스트 유효성 검사
/// - [bool] - [isValidItemName] : 상품 이름 유효성 검사
/// - [bool] - [isValidItemDescription] : 상품 설명 유효성 검사
/// - [bool] - [isValidItemPrice] : 상품 가격 유효성 검사
/// - [bool] - [isValidItemPriceStatic] : 상품 가격 유효성 검사 (static)
/// - [bool] - [isValidFeelingOfUse] : 사용감 정보 유효성 검사
/// - [bool] - [isValidItemModel] : ItemModel 유효성 검사
/// - [String] - [convertFromIntToFormalString] : 상품 가격 표기 변경
/// - [int] - [maxCountOfItemImage] : 상품 이미지 리스트 최대 개수 반환
/// - [double] - [squareHeightOfImage] : 상품 이미지 정사각형 높이 반환
/// - [int] - [crossAxisCountOfImageList] : 상품 이미지 가로 개수 반환
/// - [double] - [containerHeightOfImageList] : 상품 이미지 Container 높이 반환
/// - [String] - [printItemCategoryToString] : 상품 카테고리 리스트 문자열 반환
/// - [void] - [swapItemImageListIndex] : 상품 이미지 리스트 인덱스 변경
/// - [String] - [printItemFeelingOfUseToString] : 사용감 정보 문자열 반환
/// - [Uint8List] - [feelingOfUseExampleImage] : 사용감 정보 예시 이미지 반환
/// - [IconData] - [feelingOfUseIcon] : 사용감 아이콘 반환
/// - [Map]<[String], [dynamic]>] - [toJson] : 모델을 JSON 형태로 변환
/// - [ItemModel] - [fromJson] : JSON 형태를 모델로 변환
///
class ItemModel {
  /// ### 상품 카테고리 리스트
  final CategoryModel? itemCategory;

  /// ### 상품 이미지 리스트
  final List<Uint8List> itemImageList;

  /// ### 상품 이름
  final String? itemName;

  /// ### 상품 설명
  final String? itemDescription;

  /// ### 상품 가격
  ///
  /// - 사용자가 입력하거나 추천된 가격
  ///
  final int? itemPrice;

  /// ### 사용감 정보
  ///
  /// - 0 : 미개봉
  /// - 1 : 단순 개봉
  /// - 2 : 사용감 있음
  /// - 3 : 사용감 많음
  /// - 4 : 파손 흔적 또는 고장 있음
  ///
  final double feelingOfUse;

  ItemModel({
    required this.itemCategory,
    required this.itemImageList,
    this.itemName,
    this.itemDescription,
    this.itemPrice,
    required this.feelingOfUse,
  });

  /// ### 초기 상태 반환
  static ItemModel initial() {
    return ItemModel(
      itemCategory: null,
      itemImageList: [],
      feelingOfUse: 0,
    );
  }

  /// ### 모델 업데이트 메서드
  ItemModel copyWith({
    CategoryModel? itemCategory,
    bool? setToNullItemCategory,
    List<Uint8List>? itemImageList,
    String? itemName,
    String? itemDescription,
    int? itemPrice,
    bool? setToNullItemPrice,
    double? feelingOfUse,
  }) {
    return ItemModel(
      itemCategory: (setToNullItemCategory == true)
          ? null
          : (itemCategory ?? this.itemCategory),
      itemImageList: itemImageList ?? this.itemImageList,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      itemPrice:
          (setToNullItemPrice == true) ? null : (itemPrice ?? this.itemPrice),
      feelingOfUse: feelingOfUse ?? this.feelingOfUse,
    );
  }

  /// ### 상품 이미지 개수 반환
  ///
  /// - 버튼을 고려하여, 상품 이미지 리스트 개수 + 1 반환
  ///
  /// #### Returns
  /// - [int] - 버튼을 고려한 상품 이미지 개수
  ///
  int countOfItemImage() {
    return itemImageList.length + 1;
  }

  /// ### 상품 카테고리 리스트 유효성 검사
  ///
  /// - 상품 카테고리가 null인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemCategory() {
    return itemCategory != null;
  }

  /// ### 상품 이미지 리스트 유효성 검사
  ///
  /// - 상품 이미지 리스트가 비어있는 경우 false 반환
  /// - 상품 이미지 리스트 개수가 최대 개수를 초과하는 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemImageList() {
    return itemImageList.isNotEmpty && !isMaxCountOfItemImageList();
  }

  /// ### 상품 이미지 리스트 최대 개수 초과 여부 반환
  ///
  /// #### Returns
  /// - [bool] - 최대 개수 초과 여부
  ///
  bool isMaxCountOfItemImageList() {
    return countOfItemImage() > maxCountOfItemImage();
  }

  /// ### 상품 이름 유효성 검사
  ///
  /// - 상품 이름이 비어있거나 5글자 미만인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemName() {
    final String? itemName = this.itemName;
    if (itemName == null) return false;

    return itemName.length >= 5 && itemName.length <= 30;
  }

  /// ### 상품 설명 유효성 검사
  ///
  /// - 상품 설명이 비어있거나 10글자 미만인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemDescription() {
    final String? itemDescription = this.itemDescription;

    if (itemDescription == null) return false;

    return itemDescription.length >= 10 && itemDescription.length <= 300;
  }

  /// ### 상품 가격 유효성 검사
  ///
  /// - 상품 가격이 비어있거나 0원 미만, 100,000,000,000원 이상인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemPrice() {
    if (itemPrice == null) {
      return false;
    }

    return isValidItemPriceStatic(itemPrice ?? 0);
  }

  /// ### 상품 가격 유효성 검사 (static)
  /// - 상품 가격이 0원 미만, 100,000,000,000원 이상인 경우 false 반환
  ///
  /// #### Parameters
  /// - [int] - [price] : 상품 가격
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  static bool isValidItemPriceStatic(int price) {
    return price >= 0 && price <= 100000000000;
  }

  /// ### 사용감 정보 유효성 검사
  ///
  /// - 사용감 정보가 비어있거나 0 미만, 4 초과인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidFeelingOfUse() {
    return feelingOfUse >= 0 && feelingOfUse <= 4;
  }

  /// ### ItemModel 유효성 검사
  ///
  /// - 모든 필드가 유효한 경우 true 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemModel() {
    return isValidItemCategory() &&
        isValidItemImageList() &&
        isValidItemName() &&
        isValidItemDescription() &&
        isValidItemPrice() &&
        isValidFeelingOfUse();
  }

  /// ### 상품 가격 표기 변경
  ///
  /// - 원래 가격이 10000원인 경우, 10,000원으로 반환
  ///
  /// #### Returns
  /// - [String] - 표기 변경된 가격
  ///
  String convertFromIntToFormalString() {
    String itemPriceString = itemPrice.toString();

    /// 정규식을 사용하여 3자리마다 콤마(,) 추가
    itemPriceString = itemPriceString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    printd('itemPriceString : $itemPriceString');

    return itemPriceString;
  }

  /// ### 상품 이미지 리스트 최대 개수 반환
  int maxCountOfItemImage() {
    return 5;
  }

  /// ### 상품 이미지 정사각형 높이 반환
  double squareHeightOfImage() {
    return 130;
  }

  /// ### 상품 이미지 가로 개수 반환
  int crossAxisCountOfImageList(double screenWidth) {
    return (screenWidth / squareHeightOfImage()).floor();
  }

  /// ### 상품 이미지 Container 높이 반환
  ///
  /// - 화면 너비를 입력 받아 상품 이미지 Container 높이 반환
  ///
  /// #### Parameters
  /// - [double] - [screenWidth] : 화면 너비
  ///
  /// #### Returns
  /// - [double] - 상품 이미지 Container 높이
  ///
  double containerHeightOfImageList(double screenWidth) {
    // 정사각형이 몇 개 가로로 들어갈 수 있는지 계산
    int crossAxisCountOfImageList =
        (screenWidth / squareHeightOfImage()).floor();

    // Container 높이 구하기 (현재 아이템 갯수 / 가로 개수 * 정사각형 높이).ceilToDouble() + 16(여백)
    return ((countOfItemImage()) / crossAxisCountOfImageList).ceilToDouble() *
            squareHeightOfImage() +
        16;
  }

  /// ### 상품 카테고리 문자열 반환
  ///
  /// - 상품 카테고리를 문자열로 반환
  ///
  /// #### Returns
  /// - [String] - 상품 카테고리 문자열
  ///
  String printItemCategoryToString() {
    if (itemCategory == null) {
      return "addItem.itemCategory.selectCategory";
    }

    return (itemCategory as CategoryModel).category.name;
  }

  /// ### 사용감 정보 문자열 반환
  ///
  /// - 사용감 정보를 문자열로 반환
  ///
  /// #### Parameters
  /// - [double]? - [index] : 별도의 index가 없는 경우, [feelingOfUse] 사용
  ///
  /// #### Returns
  /// - [String] 사용감 정보 문자열
  ///
  String printItemFeelingOfUseToString(double? index) {
    final double switchIndex = index ?? feelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return "addItem.feelingOfUse.label.unopened.title";
      case 1:
        return "addItem.feelingOfUse.label.simpleUnpack.title";
      case 2:
        return "addItem.feelingOfUse.label.used.title";
      case 3:
        return "addItem.feelingOfUse.label.muchUsed.title";
      case 4:
        return "addItem.feelingOfUse.label.broken.title";
      default:
        return "addItem.feelingOfUse.description";
    }
  }

  /// TODO: 이미지 삽입
  /// ### 사용감 정보 예시 이미지 반환
  ///
  /// - 사용감 정보에 따라 예시 이미지 반환
  ///
  /// #### Returns
  /// - [Uint8List] - 사용감 정보 예시 이미지
  ///
  Uint8List feelingOfUseExampleImage(double? index) {
    final double switchIndex = index ?? feelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return Uint8List.fromList([]);
      case 1:
        return Uint8List.fromList([]);
      case 2:
        return Uint8List.fromList([]);
      case 3:
        return Uint8List.fromList([]);
      case 4:
        return Uint8List.fromList([]);
      default:
        return Uint8List.fromList([]);
    }
  }

  /// ### 사용감 정보 설명 문자열 반환
  ///
  /// #### Parameters
  /// - [double]? - [index] : 별도의 index가 없는 경우, [feelingOfUse] 사용
  ///
  /// #### Returns
  /// - [String] 사용감 정보 설명 문자열
  ///
  String printItemFeelingOfUseDescriptionToString(double? index) {
    final double switchIndex = index ?? feelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return "addItem.feelingOfUse.label.unopened.description";
      case 1:
        return "addItem.feelingOfUse.label.simpleUnpack.description";
      case 2:
        return "addItem.feelingOfUse.label.used.description";
      case 3:
        return "addItem.feelingOfUse.label.muchUsed.description";
      case 4:
        return "addItem.feelingOfUse.label.broken.description";
      default:
        return "addItem.feelingOfUse.description";
    }
  }

  /// TODO: 아이콘 변경
  /// ### 사용감 아이콘 반환
  ///
  /// - 사용감 정보에 따라 아이콘 반환
  ///
  /// #### Parameters
  /// - [double] - [index] : 사용감 정보
  ///
  /// #### Returns
  /// - [IconData] - 사용감 아이콘
  ///
  IconData feelingOfUseIcon(double index) {
    switch (index) {
      case 0:
        return CupertinoIcons.sparkles;
      case 1:
        return CupertinoIcons.envelope_open_fill;
      case 2:
        return CupertinoIcons.star_lefthalf_fill;
      case 3:
        return CupertinoIcons.star;
      case 4:
        return Icons.broken_image;
      default:
        return Icons.circle;
    }
  }

  /// ### 상품 이미지 리스트 인덱스 변경
  ///
  /// - 상품 이미지 리스트의 인덱스를 변경
  ///
  /// #### Parameters
  ///
  /// - [int] - [oldIndex] : 변경 전 인덱스
  /// - [int] - [newIndex] : 변경 후 인덱스
  ///
  void swapItemImageListIndex(int oldIndex, int newIndex) {
    // newIndex가 oldIndex보다 큰 경우, newIndex를 1 감소
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 상품 이미지 리스트에서 이미지를 꺼내고, 새로운 인덱스에 추가
    final Uint8List image = itemImageList.removeAt(oldIndex);
    itemImageList.insert(newIndex, image);
  }

  /// ### [Map]<[String], [dynamic]> - [toJson]
  /// - 모델을 JSON 형태로 변환
  ///
  /// #### Returns
  /// - [Map]<[String], [dynamic]> - JSON 형태로 변환된 모델
  ///
  Map<String, dynamic> toJson() {
    return {
      'itemCategory': itemCategory?.getItemNameLast(),
      'itemImages': itemImageList.map((e) => e.toList()).toList(),
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemFeelingOfUse': feelingOfUse,
    };
  }

  /// ### [ItemModel] - [fromJson]
  /// - JSON 형태를 모델로 변환
  ///
  /// #### Parameters
  /// - [Map]<[String], [dynamic]> - [json] : JSON 형태
  ///
  /// #### Returns
  /// - [ItemModel] - 모델로 변환된 JSON
  ///
  static ItemModel fromJson(Map<String, dynamic> json) {
    try {
      // buffer 이미지 리스트를 Uint8List로 변환
      final List<Uint8List> imageList =
          (json['itemImages'] as List).map((item) {
        final List<int> data = List<int>.from(item['data']);
        return Uint8List.fromList(data);
      }).toList();
      printd("imageList.length: ${imageList.length}");

      // TODO: double로 변환
      final feelingOfUse = json['itemFeelingOfUse'].toDouble();

      return ItemModel(
        itemCategory: CategoryModel.fromString(json['itemCategory']),
        itemImageList: imageList,
        itemName: json['itemName'],
        itemDescription: json['itemDescription'],
        itemPrice: json['itemPrice'],
        feelingOfUse: feelingOfUse,
      );
    } catch (e) {
      printd("fromJson error: $e");
      return ItemModel.initial();
    }
  }
}

/// # [ItemDetailModel]
/// - 서버로부터 받아온 상품 상세 정보를 담는 모델
/// - [ItemModel]을 extends하여 사용
///
/// ### Fields
/// - [String] - [itemUUID] : 상품 UUID
/// - [CategoryModel] - [itemCategory] : 상품 카테고리
/// - [String] - [itemName] : 상품 이름
/// - [List]<[Uint8List]> - [itemImageList] : 상품 이미지 리스트
/// - [String] - [itemDescription] : 상품 설명
/// - [int] - [itemPrice] : 상품 가격
/// - [double] - [feelingOfUse] : 사용감 정보
/// - [Location] - [itemBarterPlace] : 교환 장소
/// - [String] - [itemOwnerUUID] : 상품 소유자 UUID
/// - [DateTime] - [createdAt] : 상품 생성 시간
/// - [DateTime] - [updatedAt] : 상품 업데이트 시간
/// - [int] - [itemStatus] : 상품 등록 상태
/// - [int] - [itemViews] : 상품 조회 수
/// - [List<String>] - [itemLikedUsers] : 상품에 좋아요를 누른 사용자 UUID 리스트
///
/// ### Methods
/// - [ItemDetailModel] - [initial] : 초기 상태 반환
/// - [Map]<[String], [dynamic]> - [toJson] : 모델을 JSON 형태로 변환
/// - [ItemDetailModel] - [fromJson] : JSON 형태를 모델로 변환
///
class ItemDetailModel extends ItemModel {
  /// ### 상품 UUID
  final String itemUUID;

  /// ### 교환 장소
  final Location itemBarterPlace;

  /// ### 상품 소유자 UUID
  final String itemOwnerUUID;

  /// ### 상품 생성 시간
  final DateTime createdAt;

  /// ### 상품 업데이트 시간
  final DateTime updatedAt;

  /// ### 상품 등록 상태
  final int itemStatus;

  /// ### 상품 조회 수
  final int itemViews;

  /// ### 상품에 좋아요를 누른 사용자 UUID 리스트
  final List<String> itemLikedUsers;

  ItemDetailModel({
    required this.itemUUID,
    required this.itemBarterPlace,
    required this.itemOwnerUUID,
    required this.createdAt,
    required this.updatedAt,
    required this.itemStatus,
    required this.itemViews,
    required this.itemLikedUsers,
    required CategoryModel itemCategory,
    required List<Uint8List> itemImageList,
    required String itemName,
    required String itemDescription,
    required int itemPrice,
    required double feelingOfUse,
  }) : super(
          itemCategory: itemCategory,
          itemImageList: itemImageList,
          itemName: itemName,
          itemDescription: itemDescription,
          itemPrice: itemPrice,
          feelingOfUse: feelingOfUse,
        );

  /// ### 초기 상태 반환
  static ItemDetailModel initial() {
    return ItemDetailModel(
      itemUUID: '',
      itemCategory: CategoryModel.categories.first,
      itemBarterPlace: Location.defaultLocation,
      itemOwnerUUID: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemStatus: 0,
      itemViews: 0,
      itemLikedUsers: [],
      itemImageList: [],
      itemName: '',
      itemDescription: '',
      itemPrice: 0,
      feelingOfUse: 0,
    );
  }

  /// ### [Map]<[String], [dynamic]> - [toJson]
  /// - 모델을 JSON 형태로 변환
  ///
  /// #### Returns
  /// - [Map]<[String], [dynamic]> - JSON 형태로 변환된 모델
  ///
  @override
  Map<String, dynamic> toJson() {
    return {
      'itemUUID': itemUUID,
      'itemCategory': itemCategory?.getItemNameLast(),
      'itemImages': itemImageList.map((e) => e.toList()).toList(),
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemFeelingOfUse': feelingOfUse,
      'itemBarterPlace': itemBarterPlace.toJson(),
      'itemOwnerUUID': itemOwnerUUID,
      'itemCreatedAt': createdAt.toIso8601String(),
      'itemUpdatedAt': updatedAt.toIso8601String(),
      'itemStatus': itemStatus,
      'itemViews': itemViews,
      'itemLikedUsers': itemLikedUsers,
    };
  }

  /// ### [ItemDetailModel] - [fromJson]
  /// - JSON 형태를 모델로 변환
  ///
  /// #### Parameters
  /// - [Map]<[String], [dynamic]> - [json] : JSON 형태
  ///
  /// #### Returns
  /// - [ItemDetailModel] - 모델로 변환된 JSON
  ///
  static ItemDetailModel fromJson(Map<String, dynamic> json) {
    try {
      // buffer 이미지 리스트를 Uint8List로 변환
      final List<Uint8List> imageList =
          (json['itemImages'] as List).map((item) {
        final List<int> data = List<int>.from(item['data']);
        return Uint8List.fromList(data);
      }).toList();
      printd("imageList.length: ${imageList.length}");

      final itemUUID = json['itemUUID'];
      printd("itemUUID: $itemUUID");
      final itemName = json['itemName'];
      printd("itemName: $itemName");
      final itemDescription = json['itemDescription'];
      printd("itemDescription: $itemDescription");
      final itemPrice = json['itemPrice'];
      printd("itemPrice: $itemPrice");
      final itemOwnerUUID = json['itemOwnerUUID'];
      printd("itemOwnerUUID: $itemOwnerUUID");
      final itemStatus = json['itemStatus'];
      printd("itemStatus: $itemStatus");
      final itemViews = json['itemViews'];
      printd("itemViews: $itemViews");
      final createdAt = DateTime.parse(json['createdAt']);
      printd("createdAt: $createdAt");
      final updatedAt = DateTime.parse(json['updatedAt']);
      printd("updatedAt: $updatedAt");
      final feelingOfUse = (json['itemFeelingOfUse'] as int).toDouble();
      printd("feelingOfUse: $feelingOfUse");
      final itemCategory = CategoryModel.fromString(json['itemCategory']);
      printd("itemCategory: $itemCategory");
      final itemBarterPlace = Location.fromJson(json['itemBarterPlace']);
      printd("itemBarterPlace: $itemBarterPlace");
      final itemLikedUsers = List<String>.from(json['itemLikedUsers']);
      printd("itemLikedUsers: $itemLikedUsers");

      return ItemDetailModel(
        itemUUID: itemUUID,
        itemCategory: itemCategory,
        itemImageList: imageList,
        itemName: itemName,
        itemDescription: itemDescription,
        itemPrice: itemPrice,
        feelingOfUse: feelingOfUse,
        itemBarterPlace: itemBarterPlace,
        itemOwnerUUID: itemOwnerUUID,
        createdAt: createdAt,
        updatedAt: updatedAt,
        itemStatus: itemStatus,
        itemViews: itemViews,
        itemLikedUsers: itemLikedUsers,
      );
    } catch (e) {
      printd("fromJson error: $e");
      return ItemDetailModel.initial();
    }
  }
}
