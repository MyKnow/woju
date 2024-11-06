import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/item/location_model.dart';

import 'package:woju/service/api/vworld_api_service.dart';
import 'package:woju/service/debug_service.dart';

/// ### 물품 교환 장소 모델
/// - 네이버 지도 컨트롤러와 물품 교환 장소를 가지고 있는 모델
///
/// #### Fields
/// - [NaverMapController]? - [controller] : 네이버 지도 컨트롤러
/// - [String]? - [barterPlace] : 물품 교환 장소
///
/// #### Methods
/// - [BarterPlaceModel] - [copyWith] : [BarterPlaceModel]을 복사하여 새로운 [BarterPlaceModel]을 생성
///
class BarterPlaceModel {
  final NaverMapController? controller;
  final Location? barterPlace;
  final bool isLoading;

  BarterPlaceModel({
    this.controller,
    this.barterPlace,
    this.isLoading = false,
  });

  /// - [BarterPlaceModel]을 복사하여 새로운 [BarterPlaceModel]을 생성
  BarterPlaceModel copyWith({
    NaverMapController? controller,
    Location? barterPlace,
    bool? setToNullBarterPlace,
    bool? isLoading,
  }) {
    return BarterPlaceModel(
      controller: controller ?? this.controller,
      barterPlace: (setToNullBarterPlace == true)
          ? null
          : barterPlace ?? this.barterPlace,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final barterPlaceStateProvider = StateNotifierProvider.autoDispose<
    BarterPlaceStateNotifier, BarterPlaceModel>(
  (ref) => BarterPlaceStateNotifier(),
);

/// ### 물품 교환 장소 State Notifier
class BarterPlaceStateNotifier extends StateNotifier<BarterPlaceModel> {
  BarterPlaceStateNotifier() : super(BarterPlaceModel());

  /// ### [updateBarterPlace]
  /// - [BarterPlaceModel]을 복사하여 새로운 [BarterPlaceModel]을 생성
  void updateBarterPlace(Location? barterPlace) {
    if (barterPlace != null) {
      state = state.copyWith(barterPlace: barterPlace);
    } else {
      state = state.copyWith(setToNullBarterPlace: true);
    }
  }

  /// ### [setController]
  /// - [BarterPlaceModel]을 복사하여 새로운 [BarterPlaceModel]을 생성
  void setController(NaverMapController controller) {
    state = state.copyWith(controller: controller);
  }

  /// ### [updateIsLoading]
  /// - 로딩 상태를 변경하는 메서드
  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// ### [getController]
  /// - 현재 controller를 getter로 가져옴
  NaverMapController? get getController => state.controller;

  /// ### [getBarterPlace]
  /// - 현재 barterPlace를 getter로 가져옴
  Location? get getBarterPlace => state.barterPlace;
}

/// ### [BarterPlaceSelectPageMapAction]
/// - 교환 장소 선택 페이지에서의 Action을 관리하는 Extension
///
/// #### Methods
/// - [void] - [onMapReady] : 지도가 준비되었을 때 호출되는 메서드
/// - [void] - [onMapTapped] : 교환 장소 클릭 시 호출되는 메서드
/// - [void] - [onSymbolTapped] : 교환 장소 심볼 클릭 시 호출되는 메서드
/// - [void] - [onCameraIdle] : 카메라가 멈췄을 때 호출되는 메서드
/// - [void] - [onCameraChange] : 카메라가 이동할 때 호출되는 메서드
/// - [void] - [onPressedSetToNullBarterPlaceButton] : 교환 장소 선택 페이지에서 교환 장소를 초기화하는 메서드
///
extension BarterPlaceSelectPageMapAction on BarterPlaceStateNotifier {
  /// ### [onMapReady]
  /// - 지도가 준비되었을 때 호출되는 메서드
  /// - 네이버 지도 컨트롤러를 설정하고 화면 가운데에 마커를 생성
  ///
  /// #### Parameters
  /// - [NaverMapController] - [controller] : 네이버 지도 컨트롤러
  void onMapReady(NaverMapController controller) {
    if (getController != null) {
      printd('컨트롤러가 이미 있음');
      return;
    }

    printd('초기 컨트롤러 설정');
    setController(controller);

    // 화면 가운데에 마커 생성
    controller.addOverlay(
      NMarker(
        id: 'center',
        position: controller.nowCameraPosition.target,
      ),
    );
  }

  /// ### [onMapTapped]
  /// - 교환 장소 클릭 시 호출되는 메서드
  /// - 클릭한 위치로 카메라 이동
  ///
  /// #### Parameters
  /// - [NPoint] - [nPoint] : 선택한 위치의 화면 상에서의 위치
  /// - [NLatLng] - [nLatLng] : 선택한 교환 장소의 위도, 경도
  ///
  void onMapTapped(NPoint nPoint, NLatLng nLatLng) {
    printd('지도 클릭 : $nLatLng');

    // 클릭한 위치로 카메라 이동
    getController?.updateCamera(
      NCameraUpdate.fromCameraPosition(
        NCameraPosition(
          target: nLatLng,
          zoom: 16,
        ),
      ),
    );
  }

  /// ### [onSymbolTapped]
  /// - 교환 장소 심볼 클릭 시 호출되는 메서드
  /// - 클릭한 위치로 카메라 이동
  ///
  /// #### Parameters
  /// - [NSymbolInfo] - [nSymbol] : 선택한 심볼
  ///
  void onSymbolTapped(NSymbolInfo nSymbol) {
    printd('심볼 클릭 : ${nSymbol.caption}');
    printd("nSymbol: ${nSymbol.position}");

    // 클릭한 위치로 카메라 이동
    getController?.updateCamera(
      NCameraUpdate.fromCameraPosition(
        NCameraPosition(
          target: nSymbol.position,
          zoom: 16,
        ),
      ),
    );
  }

  /// ### [onCameraIdle]
  /// - 카메라가 멈췄을 때 호출되는 메서드
  ///
  void onCameraIdle() async {
    printd('카메라 멈춤');
    updateIsLoading(true);

    if (getController != null) {
      final controller = getController as NaverMapController;

      final target = controller.nowCameraPosition.target;
      final longitude = target.longitude;
      final latitude = target.latitude;

      final result = await VworldApiService.geoCording(latitude, longitude);

      updateIsLoading(false);

      printd('간단 주소 : ${result?.simpleName}');
      updateBarterPlace(result);
    } else {
      printd('컨트롤러가 없음');
      updateIsLoading(false);
    }
  }

  /// ### [onCameraChange]
  /// - 카메라가 이동할 때 호출되는 메서드
  ///
  /// #### Parameters
  /// - [NCameraUpdateReason] - [reason] : 카메라 이동 이유
  /// - [bool] - [isSmooth] : 부드럽게 이동하는지 여부
  ///
  void onCameraChange(NCameraUpdateReason reason, bool isSmooth) {
    if (getController != null) {
      final controller = getController as NaverMapController;
      // printd('카메라 위치 : ${controller.nowCameraPosition.target}');

      controller.addOverlay(
        NMarker(
          id: 'center',
          position: controller.nowCameraPosition.target,
        ),
      );
    }
  }

  /// ### [onPressedSetToNullBarterPlaceButton]
  /// - 교환 장소 선택 페이지에서 교환 장소를 초기화하는 메서드
  ///
  void onPressedSetToNullBarterPlaceButton() {
    updateBarterPlace(null);
  }
}
