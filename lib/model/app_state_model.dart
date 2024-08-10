import 'package:hive_flutter/hive_flutter.dart';

part 'app_state_model.g.dart';

@HiveType(typeId: 0)
class OnboardingState {
  @HiveField(0)
  final bool isAlreadyOnboarded;

  @HiveField(1)
  final bool isCompleted;

  OnboardingState({
    required this.isAlreadyOnboarded,
    required this.isCompleted,
  });

  OnboardingState copyWith({
    bool? isAlreadyOnboarded,
    bool? isCompleted,
  }) {
    return OnboardingState(
      isAlreadyOnboarded: isAlreadyOnboarded ?? this.isAlreadyOnboarded,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // default value
  static OnboardingState get initialState => OnboardingState(
        isAlreadyOnboarded: false,
        isCompleted: false,
      );
}
