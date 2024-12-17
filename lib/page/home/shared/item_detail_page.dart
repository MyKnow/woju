import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/category_model.dart';

import 'package:woju/provider/home/myItem/my_item_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/provider/shared/item_detail_state_notifier.dart';

import 'package:woju/service/adaptive_action_sheet.dart';

import 'package:woju/theme/custom_theme_data.dart';
import 'package:woju/theme/widget/adaptive_dialog.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/image_carousel.dart';

class ItemDetailPage extends ConsumerStatefulWidget {
  final String? itemUUID;

  const ItemDetailPage({super.key, this.itemUUID});

  @override
  ItemDetailPageState createState() => ItemDetailPageState();
}

class ItemDetailPageState extends ConsumerState<ItemDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData(false);
    });
  }

  Future<void> _fetchInitialData(bool isForceRefresh) async {
    final itemNotifier = ref.read(itemDetailStateProvider.notifier);
    final userToken = ref.read(userDetailInfoStateProvider)?.userToken;
    await itemNotifier.fetchItemDetail(
        widget.itemUUID, userToken, isForceRefresh);
  }

  Future<void> _deleteItem(String itemUUID) async {
    final userToken = ref.read(userDetailInfoStateProvider)?.userToken ?? '';

    ref.read(itemDetailStateProvider.notifier).updateLoading(true);

    final result = await ref.read(myItemStateProvider.notifier).deleteItem(
          userToken,
          itemUUID,
        );

    ref.read(itemDetailStateProvider.notifier).updateLoading(false);

    if (result) {
      Navigator.of(context).pop();
    } else {
      AdaptiveDialog.showAdaptiveDialog(
        context,
        title: 'common.error'.tr(),
        content: Text('itemDetail.menu.actionSheet.delete.error'.tr()),
        actions: {
          const Text('common.confirm').tr(): () {
            Navigator.of(context).pop();
          },
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = CustomThemeData.isDark(context);
    final double scale = MediaQuery.of(context).textScaleFactor;
    final itemState = ref.watch(itemDetailStateProvider);
    final userState = ref.watch(userDetailInfoStateProvider);

    return CustomScaffold(
      title: 'itemDetail.title',
      disableSafeArea: true,
      body: itemState.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _fetchInitialData(true);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // 아이템 이미지 스와이프 뷰
                  SizedBox(
                    height: 250,
                    child: ImageCarousel(
                      images: itemState.item.itemImageList,
                      imageWidth: 250,
                      scale: scale,
                    ),
                  ),

                  // 여백
                  const SizedBox(height: 8 * 5),

                  // 카테고리 & 사용감 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 여백
                      const SizedBox(width: 8),
                      // 아이템 카테고리
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        excludeFromSemantics: true,
                        onTap: () {
                          // TODO : 아이템 카테고리 설명 Page로 이동할 수 있도록 수정
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 카테고리 이름
                              CustomText(
                                itemState.item.itemCategory?.category
                                        .localizedName ??
                                    '',
                                isColorful: true,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 두꺼운 점
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        excludeFromSemantics: true,
                        onTap: () {
                          // TODO : 아이템 사용감 설명 Page로 이동할 수 있도록 수정
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 사용감 정보
                              CustomText(
                                itemState.item
                                    .printItemFeelingOfUseToString(null),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.primaryColor,
                                ),
                                isColorful: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 여백
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // // 구분선
                        // Divider(
                        //   height: 64,
                        //   thickness: 1,
                        //   color: theme.disabledColor,
                        // ),

                        // 아이템 이름
                        CustomText(
                          itemState.item.itemName ?? '',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.cardTheme.surfaceTintColor,
                          ),
                          isLocalize: false,
                          maxLines: null,
                        ),

                        // 여백
                        const SizedBox(height: 8 * 2),

                        // 업로드 시간
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                              itemState.item.createItemDateToString(),
                              // 'Test Upload Time',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.disabledColor,
                              ),
                              isLocalize: false,
                            ),
                          ],
                        ),

                        // 여백
                        const SizedBox(height: 8 * 4),

                        // 설명
                        CustomText(
                          itemState.item.itemDescription ?? '',
                          // 'Test Item Description 1' * 10,
                          isLocalize: false,
                          maxLines: null,
                        ),

                        // 여백
                        const SizedBox(height: 8 * 4),

                        // Views & Likes 확인
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // icon
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: theme.textTheme.bodySmall?.fontSize,
                              applyTextScaling: true,
                              color: theme.disabledColor,
                            ),
                            // 여백
                            const SizedBox(width: 8),
                            // Views
                            CustomText(
                              '${itemState.item.itemViews}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.disabledColor,
                              ),
                              isLocalize: false,
                            ),

                            // 여백
                            const SizedBox(width: 16),

                            InkWell(
                              onTap: () {
                                // TODO : 좋아요 기능 추가
                              },
                              child: Row(
                                children: [
                                  // icon
                                  Icon(
                                    Icons.favorite_border,
                                    size: theme.textTheme.bodySmall?.fontSize,
                                    applyTextScaling: true,
                                    color: theme.disabledColor,
                                  ),
                                  // 여백
                                  const SizedBox(width: 8),
                                  // Likes
                                  CustomText(
                                    '${itemState.item.itemLikedUsers.length}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.disabledColor,
                                    ),
                                    isLocalize: false,
                                  ),
                                ],
                              ),
                            ),

                            // 여백
                            const SizedBox(width: 16),

                            // 채팅방 수
                            Row(
                              children: [
                                // icon
                                Icon(
                                  Icons.chat_sharp,
                                  size: theme.textTheme.bodySmall?.fontSize,
                                  applyTextScaling: true,
                                  color: theme.disabledColor,
                                ),
                                // 여백
                                const SizedBox(width: 8),
                                // Likes
                                CustomText(
                                  '${itemState.item.itemMatchedUsers.length}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.disabledColor,
                                  ),
                                  isLocalize: false,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 여백
                        const SizedBox(height: 8 * 6),
                      ],
                    ),
                  ),

                  // 교환장소 정보
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 교환장소 위치 정보 지도 위젯
                      CustomDecorationContainer(
                        headerText: 'itemDetail.barterPlace',
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: NaverMap(
                            options: NaverMapViewOptions(
                              // 초기 카메라 위치
                              // TODO : 위치 정보가 없을 경우 현재 위치로 설정하도록 변경, 현재 위치 정보도 없을 경우 보정동 카페거리로 설정
                              initialCameraPosition: NCameraPosition(
                                target: NLatLng(
                                  itemState.item.itemBarterPlace.latitude,
                                  itemState.item.itemBarterPlace.longitude,
                                ),
                                zoom: 15,
                              ),
                              // 지도의 제한 영역
                              // extent: const NLatLngBounds(
                              //   southWest: NLatLng(37.413294, 126.734086),
                              //   northEast: NLatLng(37.715133, 127.269311),
                              // ),
                              // 지도 유형
                              // NMapType.basic: 기본 지도 (실내지도 지원, LiteMode 지원)
                              // NMapType.navi: 내비게이션 지도 (NightMode 지원)
                              // NMapType.satellite: 위성 지도 (위성사진만 노출
                              // NMapType.hybrid: 위성 지도 (위성사진 + 도로, 건물, 심벌 노출, LiteMode 지원)
                              // NMapType.terrain: 지형도 (지형도 + 도로, 건물, 심벌 노출, 실내지도 및 LiteMode 지원)
                              mapType: NMapType.basic,
                              // 저사양 모드 사용 여부
                              // 장점 : 메모리 소모가 적고 빠른 지도 로딩을 위한 Mode
                              // 단점: 지도 화질 저하, 실내지도 사용 불가, 레이어 그룹 사용불가, 디스플레이 옵션 변경 불가, 심벌 터치 이벤트 처리 불가, 마커/심벌 겹침 처리 불가, 줌/회전/틸트 시 지도 심벌도 함께 적용됨.
                              liteModeEnable: false,
                              // 나이트 모드 사용 여부
                              nightModeEnable: isDark,
                              // 실내 지도 사용 여부
                              indoorEnable: false,
                              // 활성화 할 레이어 그룹
                              // NLayerGroup.transit: 대중교통 레이어
                              // NLayerGroup.bicycle: 자전거 레이어
                              // NLayerGroup.traffic: 실시간 교통 레이어
                              // NLayerGroup.cadastral: 지적편집도 레이어
                              // NLayerGroup.mountain: 산악지형도 레이어
                              // NLayerGroup.building: 건물 3D 레이어
                              activeLayerGroups: [
                                NLayerGroup.transit,
                                NLayerGroup.building,
                              ],
                              // 건물 3D 높이 배율 (0: 2D, ~1: 3D)
                              buildingHeight: 1.0,
                              // 명도 (-1: 검정색 ~ 1: 흰색)
                              lightness: (isDark) ? -0.3 : 0,
                              // 심벌 크기 배율 (0~2배)
                              symbolScale: 1.0,
                              // 심볼의 원근 계수 (0~1)
                              symbolPerspectiveRatio: 0.5,
                              // 실내지도 영역 포커스 유지 반경
                              indoorFocusRadius: 100,
                              // pickable의 터치 반경
                              pickTolerance: 10,
                              // 회전 제스처 활성화 여부
                              rotationGesturesEnable: true,
                              // 스크롤 제스처 활성화 여부
                              scrollGesturesEnable: true,
                              // 틸트 제스처 활성화 여부
                              tiltGesturesEnable: true,
                              // 줌 제스처 활성화 여부
                              zoomGesturesEnable: true,
                              // 스톱 제스처 활성화 여부
                              stopGesturesEnable: true,
                              // 스크롤 제스처 마찰 계수 (0~1)
                              scrollGesturesFriction: 0.5,
                              // 줌 제스처 마찰 계수 (0~1)
                              zoomGesturesFriction: 0.5,
                              // 회전 제스처 마찰 계수 (0~1)
                              rotationGesturesFriction: 0.5,
                              // 심볼 탭 이벤트 소비 여부
                              consumeSymbolTapEvents: true,
                              // 축적 바 활성화 여부
                              scaleBarEnable: false,
                              // 실내 지도 레벨 피커 활성화 여부
                              indoorLevelPickerEnable: false,
                              // 위치 버튼 활성화 여부
                              locationButtonEnable: true,
                              // 로고 위치
                              logoAlign: NLogoAlign.leftBottom,
                              // 로고 클릭 이벤트 활성화 여부
                              logoClickEnable: true,
                              // 로고 정렬 위치
                              logoMargin: null,
                              // 컨텐츠 패딩
                              contentPadding: EdgeInsets.zero,
                              // 최소 줌 레벨
                              minZoom: 0,
                              // 최대 줌 레벨
                              maxZoom: 21,
                              // 최대 틸트 각도
                              maxTilt: 60,
                              // 지도 언어
                              locale: context.locale,
                            ),
                            // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정.
                            forceGesture: true,
                            onMapReady: (controller) {
                              // 해당 위치에 마커를 추가
                              controller.addOverlay(
                                NMarker(
                                  id: itemState.item.itemBarterPlace.simpleName,
                                  position: NLatLng(
                                    itemState.item.itemBarterPlace.latitude,
                                    itemState.item.itemBarterPlace.longitude,
                                  ),
                                ),
                              );
                            },
                            // onMapTapped: (point, latlng) {
                            //   // TODO :지도를 탭했을 때 카메라를 초기 위치로 이동
                            //   // controller.setCameraPosition(NCameraPosition(
                            // },
                            // onSymbolTapped: stateNotifier.onSymbolTapped,
                            // onCameraChange: stateNotifier.onCameraChange,
                            // onCameraIdle: stateNotifier.onCameraIdle,
                            // onSelectedIndoorChanged: (indoor) {},
                          ),
                        ),
                      ),

                      // 여백
                      const SizedBox(height: 8),

                      // 교환장소 이름
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          itemState.item.itemBarterPlace.fullAddress,
                          // 'Test Barter Place Name',
                          isLocalize: false,
                        ),
                      ),
                    ],
                  ),

                  // 여백
                  const SizedBox(height: 16 * 8),
                ],
              ),
            ),
      floatingActionButtonChild: ElevatedButton(
        onPressed: () {
          itemState.isMyItem(userState?.userUUID ?? "") == true
              ? AdaptiveActionSheet.show(
                  context,
                  title: 'itemDetail.menu.actionSheet.title',
                  actions: {
                    const Text("itemDetail.menu.actionSheet.edit").tr(): () {
                      Navigator.of(context).pop();

                      ref
                          .read(itemDetailStateProvider.notifier)
                          .pushItemEditPage(context);
                    },
                    // 빨간 글씨로 표시
                    const Text(
                      "itemDetail.menu.actionSheet.delete.title",
                      style: TextStyle(color: Colors.red),
                    ).tr(): () {
                      Navigator.of(context).pop();

                      AdaptiveDialog.showAdaptiveDialog(
                        context,
                        title: 'itemDetail.menu.actionSheet.delete.title'.tr(),
                        content: Text(
                          'itemDetail.menu.actionSheet.delete.content'.tr(),
                        ),
                        actions: {
                          const Text(
                            'itemDetail.menu.actionSheet.delete.confirm',
                            style: TextStyle(color: Colors.red),
                          ).tr(): () async {
                            Navigator.of(context).pop();

                            await _deleteItem(itemState.item.itemUUID);
                          },
                          const Text('common.cancel').tr(): () {
                            Navigator.of(context).pop();
                          },
                        },
                      );
                    },
                  },
                )
              : null;
        },
        child: Row(
          children: [
            Icon(
              Icons.menu,
              size: theme.textTheme.bodyMedium?.fontSize,
              applyTextScaling: true,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const CustomText(
              'itemDetail.menu.open',
              isWhite: true,
            ),
          ],
        ),
      ),
    );
  }
}
