// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingStateAdapter extends TypeAdapter<OnboardingState> {
  @override
  final int typeId = 0;

  @override
  OnboardingState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingState(
      isAlreadyOnboarded: fields[0] as bool,
      isSignIn: fields[1] as bool,
      gotoSignIn: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isAlreadyOnboarded)
      ..writeByte(1)
      ..write(obj.isSignIn)
      ..writeByte(2)
      ..write(obj.gotoSignIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
