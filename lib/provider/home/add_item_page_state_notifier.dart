import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/add_item_state_model.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/image_editor_service.dart';
import 'package:woju/service/image_picker_service.dart';
import 'package:woju/service/toast_message_service.dart';

final addItemPageStateProvider =
    StateNotifierProvider<AddItemPageStateNotifier, AddItemStateModel>(
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
  void updateItemCategoryList(List<CategoryModel> itemCategoryList) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemCategoryList: itemCategoryList),
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
  void updateItemPrice(int itemPrice) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(itemPrice: itemPrice),
    );
  }

  /// ### 사용감 정보 업데이트 메서드
  void updateFeelingOfUse(int feelingOfUse) {
    state = state.copyWith(
      itemModel: state.itemModel.copyWith(feelingOfUse: feelingOfUse),
    );
  }

  /// ### 교환 장소 업데이트 메서드
  void updateBarterPlace(String barterPlace) {
    state = state.copyWith(barterPlace: barterPlace);
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
      if (!getState.itemModel.isMaxCountOfItemImageList()) {
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
      } else {
        printd("최대 이미지 개수를 초과했습니다.");
        ToastMessageService.show(
          "addItem.imageAddButton.toast.maxCount",
        );
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
}
