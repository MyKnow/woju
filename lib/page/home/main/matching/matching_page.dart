import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/item/category_model.dart';
import 'package:woju/model/item/item_model.dart';

import 'package:woju/provider/home/bottom_bar_state_notifier.dart';
import 'package:woju/provider/home/matching/match_page_state_notifier.dart';

import 'package:woju/service/debug_service.dart';

import 'package:woju/theme/widget/custom_text.dart';

class MatchingPage extends ConsumerStatefulWidget {
  const MatchingPage({super.key});

  @override
  ConsumerState<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends ConsumerState<MatchingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1초 뒤에 실행
      Future.delayed(Duration.zero, () {
        ref.read(matchPageStateProvider.notifier).fetchMyItems();
      });
    });
    super.initState();
  }

  // 페이지에 재진입할 때마다 fetchItems를 실행한다.
  @override
  void didChangeDependencies() {
    printd("didChangeDependencies");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(matchPageStateProvider).isLoading != true) {
        ref.read(matchPageStateProvider.notifier).fetchMyItems();
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final matchPageState = ref.watch(matchPageStateProvider);

    return Scaffold(
      body: matchPageState.isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildLoadedState(matchPageState, context, ref),
    );
  }

  Widget _buildLoadedState(
      MatchPageState matchPageState, BuildContext context, WidgetRef ref) {
    if (matchPageState.myItems.isEmpty) {
      return _emptyMyItems();
    }
    return _loadedMyItems(matchPageState, context, ref);
  }

  // My Items가 비어있을 때
  // 내 아이템이 없음을 알리고, 아이템이 있어야 아이템을 추천 받을 수 있다는 안내를 한다.
  // 아이템을 등록하러 가기 버튼을 누르면 아이템 등록 페이지로 이동한다.
  Widget _emptyMyItems() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        const CustomText("matchingPage.emptyMyItems.title"),
        const CustomText("matchingPage.emptyMyItems.description"),
        const SizedBox(
          height: 8 * 2,
        ),
        ElevatedButton(
          onPressed: () {
            context.push('/addItem');
            ref.read(bottomBarStateProvider.notifier).setIndex(2);
          },
          child: const CustomText(
            "matchingPage.emptyMyItems.button",
            isWhite: true,
          ),
        ),
      ],
    );
  }

  /// My Items가 있을 때
  /// 추천 아이템을 보여준다.
  /// 추천 아이템이 없을 경우에는 "추천 아이템이 없습니다."를 보여준다.
  Widget _loadedMyItems(
    MatchPageState matchPageState,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (matchPageState.recommendedItems.isEmpty) {
      return _emptyRecommendedItems();
    }
    if (matchPageState.selectedItem == null) {
      return _emptySelectedItem(matchPageState, context, ref);
    }
    return _loadedRecommendedItems(matchPageState, context, ref);
  }

  /// selectedItem이 없을 경우
  /// 내 아이템 중에 하나를 선택할 수 있는 List를 보여준다.
  /// 선택한 아이템은 교환 할 아이템으로 선택된다.
  ///
  Widget _emptySelectedItem(
    MatchPageState matchPageState,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 8 * 2,
        ),
        const CustomText("matchingPage.selectItem", isTitle: true),
        const SizedBox(
          height: 8 * 2,
        ),
        ListView.builder(
          itemCount: matchPageState.myItems.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = matchPageState.myItems[index];
            return ListTile(
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.memory(
                  item.itemImageList.first,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: CustomText(item.itemName ?? "Unknown Item"),
              subtitle: CustomText(
                item.itemCategory?.category.localizedName ?? "Unknown Category",
              ),
              onTap: () {
                ref.read(matchPageStateProvider.notifier).selectItem(item);
              },
            );
          },
        ),
      ],
    );
  }

  /// 추천 아이템이 있을 경우
  /// 추천 아이템에게 Like하거나 UnLike할 수 있는 스와이프형 카드들을 보여준다.
  /// (틴더처럼)
  Widget _loadedRecommendedItems(
    MatchPageState matchPageState,
    BuildContext context,
    WidgetRef ref,
  ) {
    final items = matchPageState.recommendedItems;

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                return Positioned(
                  top: 16 * index.toDouble(),
                  child: Draggable(
                    axis: Axis.horizontal,
                    feedback: _buildCard(item, context, ref, isDragging: true),
                    childWhenDragging: const SizedBox.shrink(),
                    onDragUpdate: (details) {
                      printd("onDragUpdate: ${details.localPosition.dx.abs()}");
                      ref
                          .read(matchPageStateProvider.notifier)
                          .onDragUpdateChange(details);
                    },
                    onDragEnd: (details) {
                      ref
                          .read(matchPageStateProvider.notifier)
                          .onDragEndRequest(context, item.itemUUID);
                    },
                    child: _buildCard(item, context, ref, index: index),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: CustomText(
            textAlign: TextAlign.center,
            matchPageState.isSwipeToLike == null
                ? "matchingPage.swipeToWhatYouWant"
                : matchPageState.isSwipeToLike == true
                    ? "matchingPage.swipeToLike"
                    : "matchingPage.swipeToUnlike",
            style: TextStyle(
              color: matchPageState.isSwipeToLike == null
                  ? Theme.of(context).primaryColor
                  : matchPageState.isSwipeToLike == true
                      ? Colors.green
                      : Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 8 * 16),
      ],
    );
  }

  Widget _buildCard(
    ItemDetailModel item,
    BuildContext context,
    WidgetRef ref, {
    bool isDragging = false,
    int index = 0,
  }) {
    return Transform.scale(
      scale: isDragging ? 1.05 : 1 + index * 0.05,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: () {
            context.push('/item/${item.itemUUID}');
          },
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              color: Theme.of(context).cardTheme.color,
              boxShadow: isDragging
                  ? [
                      BoxShadow(
                        color: Theme.of(context).disabledColor,
                        blurRadius: 30,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      item.itemCategory?.category.localizedName ??
                          "Unknown Category",
                      isTitle: true,
                      isColorful: true,
                    ),
                    // Divider로 dot을 만들어 카테고리와 아이템 이름을 구분한다.
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 4,
                      child: Divider(
                        color: Theme.of(context).primaryColor,
                        thickness: 4,
                      ),
                    ),
                    // 상품 상태
                    CustomText(
                      item.printItemFeelingOfUseToString(null),
                      isTitle: true,
                      isColorful: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 24,
                  child: CustomText(
                    item.itemName ?? "Unknown Item",
                    isTitle: true,
                    maxLines: 1,
                    isLocalize: false,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Image.memory(
                    item.itemImageList.first,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                // 간략 위치 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ),
                    CustomText(
                      item.itemBarterPlace.simpleName,
                      isColorful: true,
                      isLocalize: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 추천 아이템이 없을 경우
  /// 추천 아이템이 없다는 문구를 보여준다.
  Widget _emptyRecommendedItems() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        CustomText(
          "matchingPage.emptyRecommendedItems.title",
          isTitle: true,
        ),
        SizedBox(
          height: 8 * 3,
        ),
        CustomText("matchingPage.emptyRecommendedItems.description"),
      ],
    );
  }
}
