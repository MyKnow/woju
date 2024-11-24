import 'package:flutter/material.dart';

import 'package:woju/model/item/item_model.dart';
import 'package:woju/model/item/location_model.dart';

/// # AddItemStateModel
///
/// - 상품 등록 상태를 담는 모델
///
/// ### Fields
///
/// - [ItemModel] - [itemModel] : 상품 정보
/// - [Location]? - [barterPlace] : 교환 장소
/// - [TextEditingController] - [priceController] : 상품 가격 입력 컨트롤러
/// - [bool] - [isLoading] : 로딩 상태
///
/// ### Methods
///
/// - [AddItemStateModel] - [initial] : 초기 상태 반환
/// - [bool] - [isValidBarterPlace] : 교환 장소 유효성 검사
/// - [String] - [getBarterPlaceSimpleName] : 교환 장소 문자열 반환
/// - [bool] - [isValidAddItem] : 상품 등록 유효성 검사
/// - [Map]<[String], [dynamic]>] - [toJson] : 모델을 JSON 형태로 변환
///
///
class AddItemStateModel {
  /// ### 상품 정보
  final ItemModel itemModel;

  /// ### 교환 장소
  final Location? barterPlace;

  /// ### 상품 가격 입력 컨트롤러
  final TextEditingController priceController;

  /// ### 로딩 상태
  final bool isLoading;

  /// ### 교환 장소 유효성 검사
  bool isValidBarterPlace() {
    return barterPlace != null && (barterPlace as Location).isValid();
  }

  AddItemStateModel({
    required this.itemModel,
    this.barterPlace,
    required this.priceController,
    this.isLoading = false,
  });

  /// ### 초기 상태 반환
  static AddItemStateModel initial() {
    return AddItemStateModel(
      itemModel: ItemModel.initial(),
      priceController: TextEditingController(),
    );
  }

  /// ### 모델 업데이트 메서드
  AddItemStateModel copyWith({
    ItemModel? itemModel,
    Location? barterPlace,
    bool? setToBullBarterPlace,
    TextEditingController? priceController,
    bool? isLoading,
  }) {
    return AddItemStateModel(
      itemModel: itemModel ?? this.itemModel,
      barterPlace: (setToBullBarterPlace == true)
          ? null
          : barterPlace ?? this.barterPlace,
      priceController: priceController ?? this.priceController,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// ### [String] - [getBarterPlaceSimpleName]
  /// - 교환 장소의 간단한 이름을 반환합니다.
  ///
  /// #### Returns
  /// - [String] - 교환 장소 문자열
  ///
  String getBarterPlaceSimpleName() {
    return barterPlace?.simpleName ?? 'addItem.barterPlace.empty';
  }

  /// ### [bool] - [isValidAddItem]
  /// - 상품 등록 유효성 검사
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidAddItem() {
    return itemModel.isValidItemModel() && isValidBarterPlace();
  }

  /// ### [Map]<[String], [dynamic]>] - [toJson]
  /// - 모델을 JSON 형태로 변환
  ///
  /// #### Returns
  /// - [Map]<[String], [dynamic]>] - JSON 형태의 모델
  ///
  Map<String, dynamic> toJson() {
    // itemModel의 Map에 barterPlace의 Map을 추가
    final Map<String, dynamic> itemModelJson = itemModel.toJson();
    itemModelJson['itemBarterPlace'] = barterPlace?.toJson();

    return itemModelJson;
  }
}
