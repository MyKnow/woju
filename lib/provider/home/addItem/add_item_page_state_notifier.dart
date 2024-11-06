import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/item/add_item_state_model.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/model/item/item_model.dart';
import 'package:woju/model/item/location_model.dart';

import 'package:woju/service/debug_service.dart';
import 'package:woju/service/image_editor_service.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/image_zoom_dialog.dart';
import 'package:woju/service/toast_message_service.dart';

final addItemPageStateProvider = StateNotifierProvider.autoDispose<
    AddItemPageStateNotifier, AddItemStateModel>(
  (ref) => AddItemPageStateNotifier(),
);

/// # AddItemPageStateNotifier
///
/// - 상품 등록 페이지 상태를 관리하는 노티파이어
/// - [ItemModel]을 가지는 [AddItemStateModel]을 상태로 관리
///
/// ### Methods
///
/// - [AddItemPageStateNotifier] - [initial] : 초기 상태 반환
///
class AddItemPageStateNotifier extends StateNotifier<AddItemStateModel> {
  AddItemPageStateNotifier() : super(AddItemStateModel.initial());

  /// ### 상품 등록 페이지 상태 초기화
  void initial() {
    state = AddItemStateModel.initial();
  }

  /// ### 상품 이미지 업데이트 메서드
  void updateItemImageList(List<Uint8List> itemImageList) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemImageList: itemImageList),
    );
  }

  /// ### 상품 카테고리 업데이트 메서드
  void updateItemCategory(CategoryModel? itemCategory) {
    if (itemCategory == null) {
      return;
    }

    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemCategory: itemCategory),
    );
  }

  /// ### 상품 이름 업데이트 메서드
  void updateItemName(String itemName) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemName: itemName),
    );
  }

  /// ### 상품 설명 업데이트 메서드
  void updateItemDescription(String itemDescription) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemDescription: itemDescription),
    );
  }

  /// ### 상품 가격 업데이트 메서드
  void updateItemPrice(int? itemPrice) {
    if (itemPrice == null) {
      state = state.copyWith(
        itemModel: state.itemModel.copyWith(setToNullItemPrice: true),
      );
    } else {
      state = state.copyWith(
        itemModel: state.itemModel.copyWith(
          itemPrice: itemPrice,
        ),
      );
    }
  }

  /// ### 사용감 정보 업데이트 메서드
  void updateFeelingOfUse(double feelingOfUse) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(feelingOfUse: feelingOfUse),
    );
  }

  /// ### 교환 장소 업데이트 메서드
  void updateBarterPlace(Location? barterPlace) {
    if (barterPlace == null) {
      state = state.copyWith(
        setToBullBarterPlace: true,
      );
      return;
    }
    state = state.copyWith(barterPlace: barterPlace);
  }

  /// ### 가격 입력 컨트롤러 업데이트 메서드
  ///
  /// - 가격 입력 컨트롤러를 업데이트함.
  ///
  /// #### Parameters
  /// - [TextEditingController] - [priceController] : 가격 입력 컨트롤러
  void updatePriceController(TextEditingController priceController) {
    state = state.copyWith(priceController: priceController);
  }

  /// ### 상태 반환 getter
  AddItemStateModel get getState => state;
}

/// ### AddItemPageAction
///
/// - 상품 등록 페이지에서의 Action을 관리하는 Extension
///
/// ### Methods
///
/// - [void] [onClickImageAddButton] : 이미지 추가 버튼 클릭 메서드
/// - [void] [onClickImageDeleteButton] : 이미지 삭제 버튼 클릭 메서드
/// - [void] [onClickImageEditButton] : 이미지 수정 버튼 클릭 메서드
/// - [void] [onClickSetMainImageButton] : 대표 이미지로 변경 버튼 클릭 메서드
/// - [void] [onClickAdaptiveActionSheetButton] : AdaptiveActionSheet의 버튼 클릭 메서드
/// - [void] [onClickCategorySelectButton] : 카테고리 선택 버튼 클릭 메서드
/// - [void] [onClickFeelingOfUseGuideButton] : 사용감 정보 가이드 버튼 클릭 메서드
/// - [void] [onClickBarterPlaceSelectButton] : 교환 장소 선택 버튼 클릭 메서드
///
extension AddItemPageAction on AddItemPageStateNotifier {
  /// ### AdaptiveActionSheet의 버튼 클릭 메서드
  ///
  /// - 각 텍스트에 대한 버튼을 클릭하면 해당 메서드를 호출하고, 이후 context를 닫아줌
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 컨텍스트
  /// - [Function] - [onPressed] : 버튼 클릭 시 실행할 함수
  ///
  VoidCallback onClickAdaptiveActionSheetButton(
    BuildContext context,
    Function onPressed,
  ) {
    return () async {
      // 버튼 클릭 시 실행할 함수 호출
      // onPressed가 async 함수라면 비동기 함수로 호출
      if (onPressed is Future Function()) {
        await onPressed();
      } else {
        onPressed();
      }

      if (context.mounted) {
        printd("Navigator pop by onClickAdaptiveActionSheetButton");
        Navigator.pop(context);
      }
    };
  }

  /// ### 이미지 추가 버튼 클릭 메서드
  VoidCallback onClickImageAddButton(BuildContext context,
      {bool isFromCamera = false}) {
    return () async {
      printd('이미지 추가 버튼 클릭');
      Uint8List? originalResult;
      if (isFromCamera) {
        originalResult =
            await ImagePickerService().pickImageForCameraWithUint8List();
      } else {
        originalResult =
            await ImagePickerService().pickImageForGalleryWithUint8List();
      }

      if (originalResult != null && context.mounted) {
        final editResult = await ImageEditorService.openCropEditor(
          originalResult,
          context,
        );
        if (editResult != null) {
          updateItemImageList(
            getState.itemModel.itemImageList + [editResult],
          );
        }
      }
    };
  }

  /// ### 이미지 삭제 버튼 클릭 메서드
  VoidCallback onClickImageDeleteButton(int index) {
    return () {
      printd('이미지 삭제 버튼 클릭 : $index');
      if (getState.itemModel.countOfItemImage() > 1) {
        List<Uint8List> newItemImageList =
            List.from(getState.itemModel.itemImageList);
        newItemImageList.removeAt(index);
        updateItemImageList(newItemImageList);
      }
    };
  }

  /// ### 이미지 수정 버튼 클릭 메서드
  ///
  /// #### Parameters
  /// - [int] - [index] : 수정할 이미지의 인덱스
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  VoidCallback onClickImageEditButton(int index, BuildContext context) {
    return () async {
      printd('이미지 수정 버튼 클릭 : $index');

      final original = getState.itemModel.itemImageList[index];
      printd("itemImageList: ${getState.itemModel.itemImageList}");

      final editResult =
          await ImageEditorService.openImageEditor(original, context);

      printd("editResult: $editResult");

      if (editResult != null) {
        /// 인덱스에 해당하는 이미지를 수정한 이미지로 리스트를 업데이트
        final editList = getState.itemModel.itemImageList;
        editList[index] = editResult;
        updateItemImageList(editList);
      } else {
        printd('이미지 수정 취소');
      }
    };
  }

  /// ### 대표 이미지로 변경 버튼 클릭 메서드
  ///
  /// #### Parameters
  /// - [int] - [index] : 대표 이미지로 변경할 이미지의 인덱스
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  VoidCallback onClickSetMainImageButton(int index, BuildContext context) {
    return () {
      printd('대표 이미지로 변경 버튼 클릭 : $index');

      getState.itemModel.swapItemImageListIndex(index, 0);

      updateItemImageList(getState.itemModel.itemImageList);
    };
  }

  /// ### 카테고리 선택 버튼 클릭 메서드
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  /// #### Returns
  /// - [void] : 카테고리 선택 페이지로 이동
  ///
  VoidCallback onClickCategorySelectButton(BuildContext context) {
    return () {
      printd('카테고리 선택 버튼 클릭');
      context.push('/addItem/categorySelect');
    };
  }

  /// ### 물품 이름 입력 메서드
  /// - 물품 이름을 입력하는 메서드
  ///
  /// #### Parameters
  /// - [String] - [itemName] : 입력한 물품 이름
  ///
  /// #### Returns
  /// - [VoidCallback] : 물품 이름을 업데이트함.
  ///
  void onChangedItemNameTextField(String itemName) {
    updateItemName(itemName);
    printd('물품 이름 입력 : ${getState.itemModel.itemName}');
  }

  /// ### 물품 설명 입력 메서드
  /// - 물품 설명을 입력하는 메서드
  ///
  /// #### Parameters
  /// - [String] - [itemDescription] : 입력한 물품 설명
  ///
  /// #### Returns
  /// - [VoidCallback] : 물품 설명을 업데이트함.
  ///
  void onChangedItemDescriptionTextField(String itemDescription) {
    updateItemDescription(itemDescription);
    printd('물품 설명 입력 : ${getState.itemModel.itemDescription}');
  }

  /// ### 사용감 정보 가이드 버튼 클릭 메서드
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  /// #### Returns
  /// - [void] : 사용감 정보 가이드 페이지로 이동
  ///
  VoidCallback onClickFeelingOfUseGuideButton(BuildContext context) {
    return () {
      printd('사용감 정보 가이드 버튼 클릭');
      context.push('/addItem/feelingOfUseGuide');
    };
  }

  /// ### 사용감 정보 선택 메서드
  /// - 사용감 정보를 선택하는 메서드
  ///
  /// #### Parameters
  /// - [double] - [feelingOfUse] : 사용감 정보
  ///
  /// #### Returns
  /// - [VoidCallback] : 사용감 정보를 업데이트함.
  ///
  void onChangedFeelingOfUseSlider(double feelingOfUse) {
    updateFeelingOfUse(feelingOfUse);
    printd('사용감 정보 선택 : ${getState.itemModel.feelingOfUse}');
  }

  /// ### 가격 입력 메서드
  /// - 물품 가격을 입력하는 메서드
  /// - 가격 입력 시 숫자만 입력 가능하도록 함.
  /// - TextController를 사용하여 가격을 입력받음.
  /// - 가격 Format은 1000단위로 콤마(,)를 찍음.
  ///
  /// #### Parameters
  /// - [String] - [itemPrice] : 입력한 물품 가격
  ///
  /// #### Returns
  /// - [VoidCallback] : 물품 가격을 업데이트함.
  ///
  void onChangedItemPriceTextField(String itemPrice) {
    if (itemPrice.isEmpty) {
      updateItemPrice(null);
      getState.priceController.text = '';
      return;
    }
    final int price = int.tryParse(itemPrice.replaceAll(',', '')) ?? 0;

    if (ItemModel.isValidItemPriceStatic(price)) {
      updateItemPrice(price);
    } else {
      // TODO : 가격 범위 안내 Toast Message
      printd('가격 범위 안내');
      ToastMessageService.show(
        "addItem.itemPrice.invalidRange".tr(),
      );
    }

    getState.priceController.text =
        getState.itemModel.convertFromIntToFormalString();

    printd('물품 가격 입력 : ${getState.itemModel.itemPrice}');
  }

  /// ### 교환 장소 선택 버튼 클릭 메서드
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  /// #### Returns
  /// - [void] : 교환 장소 선택 페이지로 이동
  ///
  VoidCallback onClickBarterPlaceSelectButton(BuildContext context) {
    return () {
      printd('교환 장소 선택 버튼 클릭');
      context.push('/addItem/barterPlaceSelect');
    };
  }
}

/// ### CategorySelectPageAction
///
/// - 카테고리 선택 페이지에서의 Action을 관리하는 Extension
///
/// ### Methods
/// - [void] [onTapCategory] : 카테고리를 클릭했을 때 호출되는 메서드
///
extension CategorySelectPageAction on AddItemPageStateNotifier {
  /// ### 카테고리 선택 메서드
  ///
  /// - 카테고리 클릭 시 호출되는 메서드
  ///
  /// #### Parameters
  /// - [CategoryModel] - [category] : 선택한 카테고리
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///

  VoidCallback onTapCategory(CategoryModel category, BuildContext context) {
    return () {
      printd('카테고리 선택 : ${category.category.name}');
      updateItemCategory(category);
      context.pop();
    };
  }
}

/// ### FeelingOfUseGuidePageAction
/// - 사용감 정보 가이드 페이지에서의 Action을 관리하는 Extension
///
/// ### Methods
/// - [void] [onTapFeelingOfUse] : 사용감 정보를 클릭했을 때 호출되는 메서드
/// - [void] [onLongPressFeelingOfUse] : 사용감 정보를 길게 클릭했을 때 호출되는 메서드
///
extension FeelingOfUseGuidePageAction on AddItemPageStateNotifier {
  /// ### 사용감 정보 선택 메서드
  ///
  /// - 사용감 정보 클릭 시 호출되는 메서드
  ///
  /// #### Parameters
  /// - [double] - [feelingOfUse] : 선택한 사용감 정보
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  VoidCallback onTapFeelingOfUse(double feelingOfUse, BuildContext context) {
    return () {
      printd('사용감 정보 선택 : $feelingOfUse');
      updateFeelingOfUse(feelingOfUse);
      context.pop();
    };
  }

  /// ### 사용감 정보 길게 클릭 메서드
  ///
  /// - 사용감 정보 길게 클릭 시 호출되는 메서드
  /// - 사용감 예시 이미지를 크게 보여주기 위해 사용
  ///
  /// #### Parameters
  /// - [double] - [feelingOfUse] : 선택한 사용감 정보
  /// - [BuildContext] - [context] : 현재 컨텍스트
  ///
  VoidCallback onLongPressFeelingOfUse(
      double feelingOfUse, BuildContext context) {
    return () {
      printd('사용감 정보 길게 클릭 : $feelingOfUse');

      ImageZoomDialog.show(
        context,
        getState.itemModel.feelingOfUseExampleImage(feelingOfUse),
      );
    };
  }
}

/// ### BarterPlaceSelectPageAction
/// - 교환 장소 선택 페이지에서의 Action을 관리하는 Extension
///
/// ### Methods
///
extension BarterPlaceSelectPageAction on AddItemPageStateNotifier {
  /// ### [onPressedSelectButton]
  /// - 교환장소 선택 완료 버튼 클릭 시 호출되는 메서드
  ///
  /// #### Parameters
  /// - [BuildContext] - [context] : 현재 컨텍스트
  /// - [String]? - [barterPlace] : 선택한 교환 장소
  ///
  VoidCallback? onPressedSelectButton(
      BuildContext context, Location? barterPlace) {
    if (barterPlace == null) {
      return null;
    }

    return () {
      printd('교환 장소 선택 완료 : ${getState.barterPlace?.simpleName}');
      updateBarterPlace(barterPlace);
      context.pop();
    };
  }

  /// ### [onPressedSetToNullBarterPlaceButton]
  /// - 교환장소 선택 취소 버튼 클릭 시 호출되는 메서드
  ///
  void onPressedSetToNullBarterPlaceButton() {
    printd('교환 장소 선택 취소');
    updateBarterPlace(null);
  }
}
