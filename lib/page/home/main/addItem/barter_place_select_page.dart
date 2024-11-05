import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/home/addItem/add_item_page_state_notifier.dart';
import 'package:woju/provider/home/addItem/barter_place_state_notifier.dart';

import 'package:woju/theme/custom_theme_data.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class BarterPlaceSelectPage extends ConsumerWidget {
  const BarterPlaceSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = CustomThemeData.isDark(context);
    final addItemPageStateNotifier =
        ref.watch(addItemPageStateProvider.notifier);

    return CustomScaffold(
      title: 'addItem.barterPlace.placeSelectPage.title',
      body: SafeArea(
        child: Column(
          children: [
            // 힌트
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: CustomText(
                'addItem.barterPlace.placeSelectPage.hint',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            ),

            // 네이버 맵
            _buildNaverMap(context, ref, isDark),

            // 위치 선택 버튼
            Consumer(
              builder: (context, ref, child) {
                final theme = Theme.of(context);
                final state = ref.watch(barterPlaceStateProvider);
                return CustomDecorationContainer(
                  headerText:
                      'addItem.barterPlace.placeSelectPage.selectLocation',
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // 여백
                      const SizedBox(width: 16),

                      // 선택된 위치 출력
                      Expanded(
                        child: (state.isLoading)
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primaryColor,
                                  ),
                                ),
                              )
                            : CustomText(
                                state.barterPlace ??
                                    'addItem.barterPlace.placeSelectPage.emptyLocation',
                                isLocalize: (state.barterPlace == null),
                              ),
                      ),

                      // 여백
                      const SizedBox(
                        width: 8,
                      ),

                      // 위치 선택 버튼
                      ElevatedButton(
                        onPressed: addItemPageStateNotifier
                            .onPressedSelectButton(context, state.barterPlace),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(90, 50),
                          maximumSize: const Size(140, 50),
                        ),
                        child: const CustomText(
                          'addItem.barterPlace.placeSelectPage.selectButton',
                          isWhite: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 네이버 맵
  Widget _buildNaverMap(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
  ) {
    final stateNotifier = ref.watch(barterPlaceStateProvider.notifier);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NaverMap(
            options: NaverMapViewOptions(
              // 초기 카메라 위치
              initialCameraPosition: const NCameraPosition(
                target: NLatLng(37.5666102, 126.9783881),
                zoom: 10,
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
              liteModeEnable: true,
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
              rotationGesturesEnable: false,
              // 스크롤 제스처 활성화 여부
              scrollGesturesEnable: true,
              // 틸트 제스처 활성화 여부
              tiltGesturesEnable: false,
              // 줌 제스처 활성화 여부
              zoomGesturesEnable: true,
              // 스톱 제스처 활성화 여부
              stopGesturesEnable: false,
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
            onMapReady: stateNotifier.onMapReady,
            onMapTapped: stateNotifier.onMapTapped,
            onSymbolTapped: stateNotifier.onSymbolTapped,
            onCameraChange: stateNotifier.onCameraChange,
            onCameraIdle: stateNotifier.onCameraIdle,
            // onSelectedIndoorChanged: (indoor) {},
          ),
        ),
      ),
    );
  }
}
