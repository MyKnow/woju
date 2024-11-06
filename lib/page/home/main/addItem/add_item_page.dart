import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/home/addItem/add_item_page_state_notifier.dart';

import 'package:woju/service/adaptive_action_sheet.dart';
import 'package:woju/service/image_zoom_dialog.dart';
import 'package:woju/service/toast_message_service.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class AddItemPage extends ConsumerWidget {
  const AddItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ### 테마
    final theme = Theme.of(context);

    /// ### addItemPageState
    final addItemPageState = ref.watch(addItemPageStateProvider);

    /// ### addItemPageStateNotifier
    final addItemPageStateNotifier =
        ref.watch(addItemPageStateProvider.notifier);

    /// ### 화면 너비
    double screenWidth = MediaQuery.of(context).size.width;

    return CustomScaffold(
      title: "addItem.title",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 상품 이미지 컨테이너
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품 이미지 추가 설명
                  if (addItemPageState.itemModel.itemImageList.isNotEmpty)
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const CustomText(
                        "addItem.imageItem.description",
                        isDisabled: true,
                      ),
                    ),

                  // 상품 이미지 리스트
                  Container(
                    height:
                        addItemPageState.itemModel.containerHeightOfImageList(
                      screenWidth,
                    ),
                    margin: const EdgeInsets.only(top: 8.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: addItemPageState.itemModel
                            .crossAxisCountOfImageList(screenWidth),
                        crossAxisSpacing: 10, // 가로 간격
                        mainAxisSpacing: 10, // 세로 간격
                        childAspectRatio: 1.0, // 정사각형 비율 유지
                      ),
                      // 첫 번째 아이템은 버튼으로 설정해야 하므로 이미지 개수에 +1 해줌
                      itemCount: addItemPageState.itemModel.countOfItemImage(),
                      itemBuilder: (context, index) {
                        // 첫 번째 아이템은 버튼으로 설정
                        if (index == 0) {
                          return _imageAddButton(
                            theme,
                            context,
                            ref,
                          );
                        }

                        // 그 외 아이템들은 정사각형으로 설정
                        // 첫 번째 아이템은 버튼이므로 이미지 인덱스를 -1 해줌
                        return _imageItem(
                          theme,
                          context,
                          ref,
                          index - 1,
                        );
                      },
                    ),
                  ),
                ],
              ),

              // 여백
              const SizedBox(height: 16),

              // 상품 카테고리 페이지 이동 컨테이너
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDecorationContainer(
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    height: 48,
                    headerText: "addItem.itemCategory.title",
                    hearderTextPadding: EdgeInsets.zero,
                    child: InkWell(
                      onTap: addItemPageStateNotifier
                          .onClickCategorySelectButton(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              addItemPageState.itemModel
                                  .printItemCategoryToString(),
                              style:
                                  theme.primaryTextTheme.bodyMedium?.copyWith(
                                color: (addItemPageState.itemModel
                                        .isValidItemCategory())
                                    ? theme.cardTheme.surfaceTintColor
                                    : theme.disabledColor.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: theme.disabledColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 상품 제목 컨테이너
              CustomTextfieldContainer(
                fieldKey: "addItem.textField.itemName",
                hintText: "addItem.itemName.hintText".tr(),
                labelTextEnable: false,
                margin: const EdgeInsets.only(top: 16.0),
                headerText: "addItem.itemName.title",
                hearderTextPadding: EdgeInsets.zero,
                onChanged: addItemPageStateNotifier.onChangedItemNameTextField,
              ),

              // 상품 설명 컨테이너
              CustomTextfieldContainer(
                fieldKey: "addItem.textField.itemDescription",
                headerText: "addItem.itemDescription.title",
                hintText: "addItem.itemDescription.hintText".tr(),
                labelTextEnable: false,
                margin: const EdgeInsets.only(top: 16.0),
                hearderTextPadding: EdgeInsets.zero,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                // inputFormatters: [],
                maxLines: 5,
                onChanged:
                    addItemPageStateNotifier.onChangedItemDescriptionTextField,
              ),

              // 여백
              const SizedBox(height: 16),

              // 사용감 슬라이더 컨테이너 (5단계)
              Column(
                children: [
                  // 사용감 슬라이더 헤더 (설명 및 설명 페이지 이동 버튼)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CustomText(
                        "addItem.feelingOfUse.description",
                        isBold: true,
                        isColorful: true,
                      ),

                      // 설명 페이지 이동 버튼
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.info_circle_fill,
                          color: theme.disabledColor,
                        ),
                        onPressed: addItemPageStateNotifier
                            .onClickFeelingOfUseGuideButton(context),
                        tooltip: "addItem.feelingOfUse.infoButton".tr(),
                        iconSize: 24,
                        splashRadius: 30,
                      ),
                    ],
                  ),

                  // 슬라이더
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color ?? theme.cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.cardTheme.shadowColor ?? theme.shadowColor,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: AnimatedToggleSwitch<double>.size(
                      current: addItemPageState.itemModel.feelingOfUse,
                      borderWidth: 1,
                      style: ToggleStyle(
                        backgroundColor: theme.cardTheme.color,
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      values: const [0.0, 1.0, 2.0, 3.0, 4.0],
                      selectedIconScale: 1.0,
                      indicatorSize: const Size.fromWidth(double.infinity),
                      iconAnimationType: AnimationType.onHover,
                      styleAnimationType: AnimationType.onHover,
                      spacing: 1.0,
                      customIconBuilder: (context, local, global) {
                        return Icon(
                          addItemPageState.itemModel
                              .feelingOfUseIcon(local.index.toDouble()),
                          // 현재 index가 선택된 항목이라면 흰색으로 출력
                          color: local.index ==
                                  addItemPageState.itemModel.feelingOfUse
                              ? Colors.white
                              : theme.disabledColor,
                        );
                      },
                      onChanged:
                          addItemPageStateNotifier.onChangedFeelingOfUseSlider,
                    ),
                  ),

                  // 라벨
                  Container(
                    width: double.infinity,
                    height: 24,
                    margin: const EdgeInsets.only(top: 8.0),
                    alignment: Alignment.center,
                    child: CustomText(
                      addItemPageState.itemModel
                          .printItemFeelingOfUseToString(null),
                      style: theme.primaryTextTheme.bodyMedium?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                ],
              ),

              // TODO: 입력창 활성화 때 스크롤이 더 올라가도록 수정 (키보드 액션바가 가리는 문제)
              // 상품 가격 컨테이너
              CustomTextfieldContainer(
                fieldKey: "addItem.textField.itemPrice",
                hintText: "addItem.itemPrice.hintText".tr(),
                headerText: "addItem.itemPrice.title",
                hearderTextPadding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                labelTextEnable: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    // 숫자만 입력 받고, context에 따라 구분자를 추가한다.
                    RegExp("""[0-9,]"""),
                  ),
                ],
                prefix: (addItemPageState.itemModel.isValidItemPrice())
                    ? const CustomText(
                        isBold: true,
                        "₩ ",
                      )
                    : null,
                onChanged: addItemPageStateNotifier.onChangedItemPriceTextField,
                onFieldSubmitted: (value) {
                  // 포커스를 해제하여 키보드를 내림
                  FocusScope.of(context).unfocus();
                },
                controller: addItemPageState.priceController,
              ),

              // 여백
              const SizedBox(height: 16),

              // 상품 교환 장소 컨테이너
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDecorationContainer(
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    height: 48,
                    headerText: "addItem.barterPlace.title",
                    hearderTextPadding: EdgeInsets.zero,
                    child: InkWell(
                      onTap: addItemPageStateNotifier
                          .onClickBarterPlaceSelectButton(
                        context,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            addItemPageState.getBarterPlaceSimpleName(),
                            style: theme.primaryTextTheme.bodyMedium?.copyWith(
                              color: (addItemPageState.isValidBarterPlace())
                                  ? theme.cardTheme.surfaceTintColor
                                  : theme.disabledColor.withOpacity(0.7),
                            ),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: theme.disabledColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 하단 여백
              const SizedBox(height: 16 * 6),
            ],
          ),
        ),
      ),

      floatingActionButtonText: "addItem.doneButton",
      // floatingActionButtonCallback: () {},
    );
  }

  /// ### 상품 이미지 추가 버튼
  ///
  /// #### Parameters
  ///
  /// - [ThemeData] - [theme] : 테마
  /// - [BuildContext] - [context] : 컨텍스트
  /// - [Ref] - [ref] : Riverpod Ref
  ///
  Widget _imageAddButton(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
  ) {
    final addItemState = ref.watch(addItemPageStateProvider);
    final addItemStateNotifier = ref.read(addItemPageStateProvider.notifier);
    final size = addItemStateNotifier.getState.itemModel.squareHeightOfImage();

    return _imageContainer(
      theme,
      size,
      Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.camera,
              color: theme.disabledColor,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "${addItemState.itemModel.countOfItemImage() - 1}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                  isLocalize: false,
                ),
                CustomText(
                  " / ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                  isLocalize: false,
                ),
                CustomText(
                  "${addItemState.itemModel.maxCountOfItemImage()}",
                  isLocalize: false,
                  isColorful: true,
                  isBold: true,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (addItemState.itemModel.isMaxCountOfItemImageList()) {
          ToastMessageService.show(
            "addItem.imageAddButton.toast.maxCount".tr(),
          );
          return;
        }

        AdaptiveActionSheet.show(
          context,
          title: "addItem.imageAddButton.actionSheet.title",
          message: "addItem.imageAddButton.actionSheet.message",
          actions: {
            const Text("addItem.imageAddButton.actionSheet.fromCamera").tr():
                addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickImageAddButton(
                context,
                isFromCamera: true,
              ),
            ),
            const Text("addItem.imageAddButton.actionSheet.fromGallery").tr():
                addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickImageAddButton(
                context,
                isFromCamera: false,
              ),
            ),
          },
        );
      },
    );
  }

  /// ### 상품 이미지 아이템
  ///
  /// #### Parameters
  ///
  /// - [ThemeData] - [theme] : 테마
  /// - [BuildContext] - [context] : 컨텍스트
  /// - [Ref] - [ref] : Riverpod Ref
  /// - [int] - [index] : 이미지 인덱스
  ///
  Widget _imageItem(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
    int index,
  ) {
    final addItemStateNotifier = ref.read(addItemPageStateProvider.notifier);
    final size = addItemStateNotifier.getState.itemModel.squareHeightOfImage();

    return _imageContainer(
      theme,
      size,
      Stack(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Image(
              image: MemoryImage(
                addItemStateNotifier.getState.itemModel.itemImageList[index],
              ),
              fit: BoxFit.fill,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: child,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: theme.disabledColor,
                );
              },
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.pencil_circle_fill,
                color: theme.primaryColor,
                size: 32,
                semanticLabel:
                    "addItem.imageItem.actionSheet.editMenuOpenButton".tr(
                  namedArgs: {
                    "index": (index + 1).toString(),
                  },
                ),
              ),
            ),
          ),

          // index가 0번이라면 대표 이미지 배너 출력
          if (index == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: theme.cardTheme.surfaceTintColor?.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    "addItem.imageItem.mainImageBanner",
                    style: theme.primaryTextTheme.labelLarge?.copyWith(
                      color: theme.cardTheme.color,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        AdaptiveActionSheet.show(
          context,
          title: "addItem.imageItem.actionSheet.title",
          message: "addItem.imageItem.actionSheet.message",
          actions: {
            const Text("addItem.imageItem.actionSheet.edit").tr():
                addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickImageEditButton(index, context),
            ),
            const Text("addItem.imageItem.actionSheet.setToMainImage").tr():
                addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickSetMainImageButton(index, context),
            ),
            const Text(
              "addItem.imageItem.actionSheet.delete",
              style: TextStyle(
                color: Colors.red,
              ),
            ).tr(): addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickImageDeleteButton(index),
            ),
          },
        );
      },
      onLongPress: () {
        // 사진을 길게 누르면 크게 보여주기
        // 손을 땔 때까지 이미지를 보여줌
        // 핀치 줌과, 스와이프하여 이미지 닫기 구현해야 함.

        ImageZoomDialog.show(
          context,
          addItemStateNotifier.getState.itemModel.itemImageList[index],
        );
      },
    );
  }

  /// ### 상품 이미지 컨테이너
  ///
  /// #### Parameters
  ///
  /// - [ThemeData] - [theme] : 테마
  /// - [double] - [size] : 상품 이미지 정사각형 높이
  /// - [Widget] - [child] : 자식 위젯
  /// - [VoidCallback] - [onTap] : 클릭 시 실행할 함수
  ///
  Widget _imageContainer(
    ThemeData theme,
    double size,
    Widget child, {
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.disabledColor,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
