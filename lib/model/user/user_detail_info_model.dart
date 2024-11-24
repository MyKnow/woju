import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/service/debug_service.dart';

part 'user_detail_info_model.g.dart';

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
    );
  }
}
