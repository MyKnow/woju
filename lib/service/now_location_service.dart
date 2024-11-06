/// ### [NowLocationService]
/// - 현재 내 위치를 가져올 때 사용하는 서비스
/// - 싱글톤 클래스로 구현되어 있습니다.
///
/// #### Methods
/// - [String] - [getNowLocation] : 현재 내 위치를 가져옵니다.
///
class NowLocationService {
  /// ### [NowLocationService] 인스턴스
  static final NowLocationService _instance = NowLocationService._();

  /// ### [NowLocationService] 생성자
  NowLocationService._();

  /// ### [NowLocationService] 인스턴스 반환
  factory NowLocationService() => _instance;

  /// ### [Future]<[Map]<[double], [double]> [getNowLocation]
  /// - 현재 내 위치를 가져옵니다.
  /// - 위도, 경도를 반환합니다.
  ///
  /// #### Parameters
  /// - [void] : 없음
  ///
  /// #### Returns
  /// - [Future]<[Map]<[double], [double]> : 위도, 경도를 반환합니다.
  ///
  Future<Map<double, double>> getNowLocation() async {
    // TODO: 위치 정보를 가져오는 로직을 추가해야 함.
    return {
      37.5665: 126.9780,
    };
  }
}
