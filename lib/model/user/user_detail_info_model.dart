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
  });

  factory UserDetailInfoModel.fromJson(Map<String, dynamic> json) {
    printd("userGender: ${json['userGender']}");
    printd("profileImage: ${json['userProfileImage']}");
    final profileImage = json['userProfileImage'];

    printd("profileImage: $profileImage");
    printd("profileImage data : ${json['userProfileImage']?['data']}");

    Uint8List? decodedData;
    if (profileImage != null) {
      decodedData =
          Uint8List.fromList(List<int>.from(json['userProfileImage']['data']));
      printd("decodedData: $decodedData");
    }

    return UserDetailInfoModel(
      userUUID: json['userUUID'],
      profileImage: decodedData,
      userID: json['userID'],
      userPhoneNumber: json['userPhoneNumber'],
      dialCode: json['dialCode'],
      isoCode: json['isoCode'],
      userUID: json['userUID'],
      userNickName: json['userNickName'],
      userGender: GenderExtension.getGenderFromString(json['userGender']),
      userBirthDate: DateTime.parse(json['userBirthDate']),
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
    );
  }
}
