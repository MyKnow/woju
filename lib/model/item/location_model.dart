/// ### [Location] Model
/// - Location은 거래 장소의 위치 정보를 담는 모델입니다.
///
/// #### Fields
/// - [String] - [simpleName] : 거래 장소의 간단한 이름 (level4나 별도의 건물명이 저장됩니다).
/// - [String] - [fullAddress] : 거래 장소의 전체 주소 (도로명 주소가 저장됩니다).
/// - [double] - [latitude] : 거래 장소의 위도.
/// - [double] - [longitude] : 거래 장소의 경도.
/// - [int] - [zipCode] : 거래 장소의 우편번호.
///
/// #### Methods
/// - [Location] Constructor : 각 필드를 받아 Location 객체를 생성합니다.
/// - factory [Location.fromJson] : JSON 데이터를 받아 Location 객체로 변환합니다.
/// - [Location.toJson] : Location 객체를 JSON 데이터로 변환합니다.
/// - [Location.copyWith] : 필드를 변경한 새로운 Location 객체를 반환합니다.
/// - [Location.isValid] : Location 객체의 유효성을 검사합니다.
///
class Location {
  final String simpleName;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final int zipCode;

  /// ### [Location] Constructor
  Location({
    required this.simpleName,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    required this.zipCode,
  });

  /// ### [Location.fromJson] : (json) Factory Method
  /// - JSON 데이터를 받아 Location 객체로 변환합니다.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      simpleName: json['simpleName'],
      fullAddress: json['fullAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      zipCode: json['zipCode'],
    );
  }

  /// ### [Location.toJson] : (json) Method
  /// - Location 객체를 JSON 데이터로 변환합니다.
  ///
  Map<String, dynamic> toJson() {
    return {
      'simpleName': simpleName,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'zipCode': zipCode,
    };
  }

  /// ### [Location.copyWith] : (fields) Method
  /// - Location 객체의 필드를 변경한 새로운 Location 객체를 반환합니다.
  /// - setToNull___ : ___ 이름의 필드를 null로 변경합니다.
  ///
  Location copyWith({
    String? simpleName,
    String? fullAddress,
    double? latitude,
    double? longitude,
    int? zipCode,
  }) {
    return Location(
      simpleName: simpleName ?? this.simpleName,
      fullAddress: fullAddress ?? this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  /// ### [Location.isValid] : (bool) Method
  /// - Location 객체의 유효성을 검사합니다.
  ///
  /// #### Returns
  /// - [bool] : 유효한 Location 객체인 경우 true를 반환합니다.
  bool isValid() {
    return simpleName.isNotEmpty &&
        fullAddress.isNotEmpty &&
        latitude != 0 &&
        longitude != 0 &&
        zipCode != 0;
  }
}
