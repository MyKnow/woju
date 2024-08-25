// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailInfoModelAdapter extends TypeAdapter<UserDetailInfoModel> {
  @override
  final int typeId = 1;

  @override
  UserDetailInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailInfoModel(
      profileImage: fields[0] as Uint8List?,
      userID: fields[1] as String,
      userPhoneNumber: fields[2] as String,
      dialCode: fields[3] as String,
      isoCode: fields[4] as String,
      userUID: fields[5] as String,
      userNickName: fields[6] as String,
      userGender: fields[7] as Gender,
      userBirthDate: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetailInfoModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.profileImage)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.userPhoneNumber)
      ..writeByte(3)
      ..write(obj.dialCode)
      ..writeByte(4)
      ..write(obj.isoCode)
      ..writeByte(5)
      ..write(obj.userUID)
      ..writeByte(6)
      ..write(obj.userNickName)
      ..writeByte(7)
      ..write(obj.userGender)
      ..writeByte(8)
      ..write(obj.userBirthDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
