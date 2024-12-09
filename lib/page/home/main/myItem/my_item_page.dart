import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/item_model.dart';

import 'package:woju/provider/home/myItem/my_item_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/provider/shared/item_detail_state_notifier.dart';

import 'package:woju/service/adaptive_action_sheet.dart';

import 'package:woju/theme/widget/custom_text.dart';

class MyItemPage extends ConsumerStatefulWidget {
  const MyItemPage({super.key});

  @override
  ConsumerState<MyItemPage> createState() => _MyItemPageState();
}

class _MyItemPageState extends ConsumerState<MyItemPage> {
  static const double imageSize = 120;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userToken = ref.watch(userDetailInfoStateProvider)?.userToken ?? "";

      _fetchInitialData(true, userToken);
    });
    super.initState();
  }

  Future<void> _fetchInitialData(bool isForced, String userToken) async {
    await ref.read(myItemStateProvider.notifier).fetchItemList(
          userToken,
          isForced,
        );
  }

  Future<void> _deleteItem(String itemUUID, String userToken) async {
    await ref.read(myItemStateProvider.notifier).deleteItem(
          userToken,
          itemUUID,
        );
  }

  Future<void> _updateItemDetail(
      ItemDetailModel item, int itemStatus, String userToken) async {
    await ref
        .read(myItemStateProvider.notifier)
        .updateItemDetail(item, itemStatus, userToken);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.of(context).textScaleFactor;

    final myItemState = ref.watch(myItemStateProvider);
    final myItemStateNotifier = ref.read(myItemStateProvider.notifier);

    final userToken = ref.watch(userDetailInfoStateProvider)?.userToken ?? "";

    return SafeArea(
      child: (myItemState.isFetching == true)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _fetchInitialData(true, userToken);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  const SizedBox(height: 8),
                  ...myItemState.getFilteredItemList().map(
                    (item) {
                      // 아이템을 필터링하여 반환한다.
                      return _buildItem(
                        item,
                        scale,
                        userToken,
                        itemImageLength: imageSize,
                        isDeleting: myItemState.isDeleting == true,
                        onTap: () => myItemStateNotifier.onTapItemDetailPage(
                          item.itemUUID,
                          context,
                        ),
                        onStartToEnd: () async {
                          ref
                              .read(itemDetailStateProvider.notifier)
                              .pushItemEditPage(context, item: item);
                        },
                        onEndToStart: () async {
                          await _deleteItem(item.itemUUID, userToken);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildItem(
    ItemDetailModel item,
    double scale,
    String userToken, {
    double? itemImageLength,
    Function()? onTap,
    Function()? onLongPress,
    Function()? onStartToEnd,
    Function()? onEndToStart,
    required bool isDeleting,
  }) {
    // 아이템 사진 길이가 없을 경우 기본값으로 설정
    itemImageLength ??= 120;

    // 현재 화면 확대 크기

    // item의 높이에 scale을 곱하여 확대한다.
    itemImageLength *= scale;

    Uint8List image;

    // 이미지가 없을 경우 기본 이미지로 설정
    if (item.itemImageList.isEmpty) {
      image = Uint8List.fromList([]);
    } else {
      image = item.itemImageList.first;
    }

    // 제목이 없을 경우 빈 문자열로 설정
    final itemName = item.itemName ?? '';

    // 테마
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key(item.itemUUID),
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: isDeleting
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
        ),
        child: Container(
          height: itemImageLength + 20,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.memory(
                  image,
                  width: itemImageLength,
                  height: itemImageLength,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              // 가로로 최대한 공간을 차지해야 함
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    itemImageLength -
                    16 * 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 아이템 상태
                    ElevatedButton(
                      onPressed: () {
                        AdaptiveActionSheet.show(
                          context,
                          title: 'myItem.itemStatusChange.actionSheet.title',
                          message:
                              'myItem.itemStatusChange.actionSheet.message',
                          actions: {
                            Text(
                              item.getItemStatusToString(itemStatus: 0),
                            ).tr(): () {
                              Navigator.of(context).pop();

                              _updateItemDetail(item, 0, userToken);
                            },
                            Text(
                              item.getItemStatusToString(itemStatus: 1),
                            ).tr(): () {
                              Navigator.of(context).pop();

                              _updateItemDetail(item, 1, userToken);
                            },
                            Text(
                              item.getItemStatusToString(itemStatus: 2),
                            ).tr(): () {
                              Navigator.of(context).pop();

                              _updateItemDetail(item, 2, userToken);
                            },
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          // padding: EdgeInsets.zero,
                          ),
                      child: CustomText(
                        item.getItemStatusToString(),
                        isWhite: true,
                        isLocalize: false,
                      ),
                    ),

                    CustomText(
                      itemName,
                      isBold: true,
                      isLocalize: false,
                      isColorful: true,
                    ),

                    // 업로드 시간
                    CustomText(
                      item.createItemDateToString(),
                      isLocalize: false,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),

                    // 세로로 최대한 공간을 차지해야 함

                    // const Spacer(),

                    // 아이템 조회수, 좋아요, 채팅 갯수
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        clipBehavior: Clip.hardEdge, // 넘치는 부분을 잘라냄
                        spacing: 16, // 각 위젯 간의 가로 간격
                        runSpacing: 4, // 줄 바꿈 시 각 줄 간의 세로 간격
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              CustomText(
                                item.itemViews.toString(),
                                isLocalize: false,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                item.itemLikedUsers.length.toString(),
                                isLocalize: false,
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                CupertinoIcons.chat_bubble_fill,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              const CustomText(
                                '0', // TODO: 실제 채팅 요청 갯수로 변경
                                isLocalize: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await onEndToStart?.call() ?? false;
          } else if (direction == DismissDirection.startToEnd) {
            return await onStartToEnd?.call() ?? false;
          }

          return false;
        },
      ),
    );
  }
}
