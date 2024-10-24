import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/home/add_item_page_state_notifier.dart';

import 'package:woju/service/adaptive_action_sheet.dart';

import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // 상품 이미지 컨테이너
                SizedBox(
                  height: addItemPageState.itemModel.containerHeightOfImageList(
                    screenWidth,
                  ),
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

                // 구분선
                Divider(
                  height: 16,
                  thickness: 1,
                  color: theme.disabledColor,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomFloatingButton.build(
        context,
        ref,
        () {},
        "addItem.doneButton",
      ),
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
            CustomText(
              "${addItemState.itemModel.countOfItemImage() - 1}/${addItemState.itemModel.maxCountOfItemImage()}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
              isLocalize: false,
            )
          ],
        ),
      ),
      () {
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
                  borderRadius: BorderRadius.circular(24),
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
            right: 4,
            top: 4,
            child: Icon(
              CupertinoIcons.pencil_circle_fill,
              color: theme.disabledColor,
              size: 32,
              semanticLabel:
                  "addItem.imageItem.actionSheet.editMenuOpenButton".tr(
                namedArgs: {
                  "index": (index + 1).toString(),
                },
              ),
            ),
          ),
        ],
      ),
      () {
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
            Text(
              "addItem.imageItem.actionSheet.delete",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
            ).tr(): addItemStateNotifier.onClickAdaptiveActionSheetButton(
              context,
              addItemStateNotifier.onClickImageDeleteButton(index),
            ),
          },
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
    Widget child,
    VoidCallback onTap,
  ) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.disabledColor,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }
}
