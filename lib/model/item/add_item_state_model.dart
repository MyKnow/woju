import 'package:woju/model/item/item_model.dart';

/// # AddItemStateModel
///
/// - 상품 등록 상태를 담는 모델
///
/// ### Fields
///
/// - [ItemModel] - [itemModel] : 상품 정보
/// - [String] - [barterPlace] : 교환 장소
/// -
/// ### Methods
///
/// - [AddItemStateModel] - [initial] : 초기 상태 반환
/// - [bool] - [isValidBarterPlace] : 교환 장소 유효성 검사
///
class AddItemStateModel {
  /// ### 상품 정보
  final ItemModel itemModel;

  /// ### 교환 장소
  final String? barterPlace;

  /// ### 교환 장소 유효성 검사
  bool isValidBarterPlace() {
    return barterPlace != null && barterPlace!.isNotEmpty;
  }

  AddItemStateModel({
    required this.itemModel,
    this.barterPlace,
  });

  /// ### 초기 상태 반환
  static AddItemStateModel initial() {
    return AddItemStateModel(itemModel: ItemModel.initial());
  }

  /// ### 모델 업데이트 메서드
  AddItemStateModel copyWith({
    ItemModel? itemModel,
    String? barterPlace,
  }) {
    return AddItemStateModel(
      itemModel: itemModel ?? this.itemModel,
      barterPlace: barterPlace ?? this.barterPlace,
    );
  }
}
