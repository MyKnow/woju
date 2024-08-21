import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/service/debug_service.dart';

part 'user_detail_info_model.g.dart';

@HiveType(typeId: 1)
class UserDetailInfoModel {
  @HiveField(0)
  final Image? profileImage;

  @HiveField(1)
  final String userID;

  @HiveField(2)
  final String userPhoneNumber;

  @HiveField(3)
  final String dialCode;

  @HiveField(4)
  final String userUID;

  @HiveField(5)
  final String userNickName;

  @HiveField(6)
  final Gender userGender;

  @HiveField(7)
  final DateTime userBirthDate;

  UserDetailInfoModel({
    this.profileImage,
    required this.userID,
    required this.userPhoneNumber,
    required this.dialCode,
    required this.userUID,
    required this.userNickName,
    required this.userGender,
    required this.userBirthDate,
  });

  factory UserDetailInfoModel.fromJson(Map<String, dynamic> json) {
    printd("userGender: ${json['userGender']}");
    return UserDetailInfoModel(
      profileImage: json['profileImage'],
      userID: json['userID'],
      userPhoneNumber: json['userPhoneNumber'],
      dialCode: json['dialCode'],
      userUID: json['userUID'],
      userNickName: json['userNickName'],
      userGender: GenderExtension.getGenderFromString(json['userGender']),
      userBirthDate: DateTime.parse(json['userBirthDate']),
    );
  }
}
