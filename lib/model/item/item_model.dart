import 'dart:typed_data';

import 'package:woju/model/item/category_model.dart';

/// # ItemModel
///
/// - 상품 정보를 담는 모델
///
/// ### Fields
///
/// - [List]<[CategoryModel]> - [itemCategoryList] : 상품 카테고리 리스트
/// - [List]<[Uint8List]> - [itemImageList] : 상품 이미지 리스트
/// - [String?] - [itemName] : 상품 이름
/// - [String?] - [itemDescription] : 상품 설명
/// - [int?] - [itemPrice] : 상품 가격
/// - [int?] - [feelingOfUse] : 사용감 정보
///
/// ### Methods
///
/// - [ItemModel] -[initial] : 초기 상태 반환
/// - [int] - [countOfItemImage] : 상품 이미지 개수 반환
/// - [bool] - [isValidItemCategoryList] : 상품 카테고리 리스트 유효성 검사
/// - [bool] - [isValidItemImageList] : 상품 이미지 리스트 유효성 검사
/// - [bool] - [isValidItemName] : 상품 이름 유효성 검사
/// - [bool] - [isValidItemDescription] : 상품 설명 유효성 검사
/// - [bool] - [isValidItemPrice] : 상품 가격 유효성 검사
/// - [bool] - [isValidFeelingOfUse] : 사용감 정보 유효성 검사
/// - [bool] - [isValidItemModel] : ItemModel 유효성 검사
/// - [String] - [printItemPriceString] : 상품 가격 표기 변경
/// - [int] - [maxCountOfItemImage] : 상품 이미지 리스트 최대 개수 반환
/// - [double] - [squareHeightOfImage] : 상품 이미지 정사각형 높이 반환
/// - [int] - [crossAxisCountOfImageList] : 상품 이미지 가로 개수 반환
/// - [double] - [containerHeightOfImageList] : 상품 이미지 Container 높이 반환
///
class ItemModel {
  /// ### 상품 카테고리 리스트
  final List<CategoryModel> itemCategoryList;

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
  final int? feelingOfUse;

  ItemModel({
    required this.itemCategoryList,
    required this.itemImageList,
    this.itemName,
    this.itemDescription,
    this.itemPrice,
    this.feelingOfUse,
  });

  /// ### 초기 상태 반환
  static ItemModel initial() {
    return ItemModel(
      itemCategoryList: [],
      itemImageList: [],
    );
  }

  /// ### 모델 업데이트 메서드
  ItemModel copyWith({
    List<CategoryModel>? itemCategoryList,
    List<Uint8List>? itemImageList,
    String? itemName,
    String? itemDescription,
    int? itemPrice,
    int? feelingOfUse,
  }) {
    return ItemModel(
      itemCategoryList: itemCategoryList ?? this.itemCategoryList,
      itemImageList: itemImageList ?? this.itemImageList,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      itemPrice: itemPrice ?? this.itemPrice,
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
  /// - 상품 카테고리 리스트가 비어있는 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemCategoryList() {
    return itemCategoryList.isNotEmpty;
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
    return itemName != null && itemName!.length >= 5;
  }

  /// ### 상품 설명 유효성 검사
  ///
  /// - 상품 설명이 비어있거나 10글자 미만인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemDescription() {
    return itemDescription != null && itemDescription!.length >= 10;
  }

  /// ### 상품 가격 유효성 검사
  ///
  /// - 상품 가격이 비어있거나 0원 미만, 100,000,000,000원 이상인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemPrice() {
    return itemPrice != null && itemPrice! > 0 && itemPrice! < 100000000000;
  }

  /// ### 사용감 정보 유효성 검사
  ///
  /// - 사용감 정보가 비어있거나 0 미만, 4 초과인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidFeelingOfUse() {
    return feelingOfUse != null && feelingOfUse! >= 0 && feelingOfUse! <= 4;
  }

  /// ### ItemModel 유효성 검사
  ///
  /// - 모든 필드가 유효한 경우 true 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemModel() {
    return isValidItemCategoryList() &&
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
  String printItemPriceString() {
    String itemPriceString = itemPrice.toString();
    return itemPriceString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// ### 상품 이미지 리스트 최대 개수 반환
  int maxCountOfItemImage() {
    return 5;
  }

  /// ### 상품 이미지 정사각형 높이 반환
  double squareHeightOfImage() {
    return 100;
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

    // Container 높이 구하기 (현재 아이템 갯수 / 가로 개수 * 정사각형 높이).ceilToDouble()
    return ((countOfItemImage()) / crossAxisCountOfImageList).ceilToDouble() *
        squareHeightOfImage();
  }
}
