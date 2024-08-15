import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final String userUID;

  @HiveField(4)
  final String userNickname;

  UserDetailInfoModel({
    this.profileImage,
    required this.userID,
    required this.userPhoneNumber,
    required this.userUID,
    required this.userNickname,
  });
}
