// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_gender_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = 2;

  @override
  Gender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Gender.private;
      case 1:
        return Gender.man;
      case 2:
        return Gender.woman;
      case 3:
        return Gender.other;
      default:
        return Gender.private;
    }
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    switch (obj) {
      case Gender.private:
        writer.writeByte(0);
        break;
      case Gender.man:
        writer.writeByte(1);
        break;
      case Gender.woman:
        writer.writeByte(2);
        break;
      case Gender.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
