import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:woju/model/item/category_model.dart' as woju;
import 'package:woju/model/user/user_gender_model.dart';

import 'package:woju/service/debug_service.dart';

part 'user_detail_info_model.g.dart';

/// # [UserDetailInfoModel]
/// - 유저 세부 정보 모델
///
/// ### Fields
/// - [String] - [userUUID]: 유저 UUID
/// - [Uint8List]? - [profileImage]: 프로필 이미지
/// - [String] - [userID]: 유저 ID
/// - [String] - [userPhoneNumber]: 유저 전화번호
/// - [String] - [dialCode]: 유저 국가번호
/// - [String] - [isoCode]: 유저 국가코드
/// - [String] - [userUID]: 유저 UID
/// - [String] - [userNickName]: 유저 닉네임
/// - [Gender] - [userGender]: 유저 성별
/// - [DateTime] - [userBirthDate]: 유저 생년월일
/// - [String]? - [termsVersion]: 약관 버전
/// - [String]? - [privacyVersion]: 개인정보 처리방침 버전
/// - [String]? - [userToken]: 유저 토큰
/// - [Map]<[woju.Category], [int]>? - [userFavoriteCategoriesList]: 유저가 즐겨찾는 카테고리 리스트
///
/// ### Methods
/// - [UserDetailInfoModel] - [fromJson]: JSON 데이터를 [UserDetailInfoModel]로 변환
/// - [UserDetailInfoModel] - [copyWith]: 필드를 변경한 새로운 [UserDetailInfoModel] 생성
///
@HiveType(typeId: 1)
class UserDetailInfoModel {
  @HiveField(0)
  final String userUUID;

  @HiveField(1)
  final Uint8List? profileImage;

  @HiveField(2)
  final String userID;

  @HiveField(3)
  final String userPhoneNumber;

  @HiveField(4)
  final String dialCode;

  @HiveField(5)
  final String isoCode;

  @HiveField(6)
  final String userUID;

  @HiveField(7)
  final String userNickName;

  @HiveField(8)
  final Gender userGender;

  @HiveField(9)
  final DateTime userBirthDate;

  @HiveField(10)
  final String? termsVersion;

  @HiveField(11)
  final String? privacyVersion;

  @HiveField(12)
  final String? userToken;

  @HiveField(13)
  final Map<woju.Category, int>? userFavoriteCategoriesMap;

  UserDetailInfoModel({
    required this.userUUID,
    this.profileImage,
    required this.userID,
    required this.userPhoneNumber,
    required this.dialCode,
    required this.isoCode,
    required this.userUID,
    required this.userNickName,
    required this.userGender,
    required this.userBirthDate,
    this.userToken,
    this.termsVersion,
    this.privacyVersion,
    this.userFavoriteCategoriesMap,
  });

  factory UserDetailInfoModel.fromJson(Map<String, dynamic> json) {
    final userInfo = json['userInfo'];
    final userToken = json['token'];

    printd("userInfo: $userInfo");
    printd("userToken: $userToken");

    final profileImage = userInfo['userProfileImage'];
    Uint8List? decodedData;
    if (profileImage != null) {
      decodedData = Uint8List.fromList(
          List<int>.from(userInfo['userProfileImage']['data']));
      printd("decodedData: $decodedData");
    }

    return UserDetailInfoModel(
      userUUID: userInfo['userUUID'],
      profileImage: decodedData,
      userID: userInfo['userID'],
      userPhoneNumber: userInfo['userPhoneNumber'],
      dialCode: userInfo['dialCode'],
      isoCode: userInfo['isoCode'],
      userUID: userInfo['userUID'],
      userNickName: userInfo['userNickName'],
      userGender: GenderExtension.getGenderFromString(userInfo['userGender']),
      userBirthDate: DateTime.parse(userInfo['userBirthDate']),
      termsVersion: userInfo['termsVersion'],
      privacyVersion: userInfo['privacyVersion'],
      userToken: userToken,
      userFavoriteCategoriesMap:
          woju.CategoryExtension.getCategoryMapFromString(
        userInfo['userFavoriteCategoriesList'],
      ),
    );
  }

  UserDetailInfoModel copyWith({
    String? userUUID,
    Uint8List? profileImage,
    String? userID,
    String? userPhoneNumber,
    String? dialCode,
    String? isoCode,
    String? userUID,
    String? userNickName,
    Gender? userGender,
    DateTime? userBirthDate,
    bool? profileImageDelete,
    String? termsVersion,
    String? privacyVersion,
    Map<woju.Category, int>? userFavoriteCategoriesList,
  }) {
    return UserDetailInfoModel(
      userUUID: userUUID ?? this.userUUID,
      profileImage:
          profileImageDelete == true ? null : profileImage ?? this.profileImage,
      userID: userID ?? this.userID,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      dialCode: dialCode ?? this.dialCode,
      isoCode: isoCode ?? this.isoCode,
      userUID: userUID ?? this.userUID,
      userNickName: userNickName ?? this.userNickName,
      userGender: userGender ?? this.userGender,
      userBirthDate: userBirthDate ?? this.userBirthDate,
      termsVersion: termsVersion ?? this.termsVersion,
      privacyVersion: privacyVersion ?? this.privacyVersion,
      userFavoriteCategoriesMap:
          userFavoriteCategoriesList ?? this.userFavoriteCategoriesMap,
    );
  }
}
