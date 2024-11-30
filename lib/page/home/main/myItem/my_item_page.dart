import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/item_model.dart';

import 'package:woju/provider/home/myItem/my_item_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';

import 'package:woju/service/debug_service.dart';

import 'package:woju/theme/widget/custom_text.dart';

class MyItemPage extends ConsumerWidget {
  const MyItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userToken = ref.read(userDetailInfoStateProvider)?.userToken ?? '';
    final double scale = MediaQuery.of(context).textScaleFactor;
    const double imageSize = 120;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(myItemStateProvider.notifier).fetchItemList(
                userToken,
                true,
              );
        },
        child: Consumer(
          builder: (context, ref, child) {
            final myItemState = ref.watch(myItemStateProvider);
            final myItemStateNotifier = ref.read(myItemStateProvider.notifier);

            if (myItemState.itemList.isEmpty && !myItemState.isFetching) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                myItemStateNotifier.fetchItemList(userToken, false);
              });

              return const Center(child: CustomText('common.noItem'));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    'myItem.myItemList.title',
                    isColorful: true,
                    isBold: true,
                  ),
                ),
                const SizedBox(height: 8),
                ...myItemState.getFilteredItemList().map(
                  (item) {
                    // 아이템을 필터링하여 반환한다.
                    return _buildItem(
                      item,
                      scale,
                      itemImageLength: imageSize,
                      isDeleting: myItemState.isDeleting,
                      onStartToEnd: () async {
                        printd('좋아요');
                      },
                      onEndToStart: () async {
                        await ref.read(myItemStateProvider.notifier).deleteItem(
                              userToken,
                              item.itemUUID,
                            );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(
    ItemDetailModel item,
    double scale, {
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

    // 설명이 없을 경우 빈 문자열로 설정
    final itemDescription = item.itemDescription ?? '';

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key(item.itemUUID),
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.favorite, color: Colors.white),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          height: itemImageLength + 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      itemName,
                      // 'sldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfa',
                      isBold: true,
                      isLocalize: false,
                      isColorful: true,
                    ),

                    // 세로로 최대한 공간을 차지해야 함
                    CustomText(
                      itemDescription,
                      // 'sldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfasldfjaksdfa',
                      isLocalize: false,
                    ),

                    const Spacer(),

                    // TODO: 아이템 관심 갯수, 채팅 요청 등을 표시하는 UI로 변경
                    // Column의 최하단에 고정되어야 함
                    const Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.chat,
                          color: Colors.blue,
                        ),
                      ],
                    )
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
