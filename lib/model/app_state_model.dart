import 'package:hive_flutter/hive_flutter.dart';

part 'app_state_model.g.dart';

@HiveType(typeId: 0)
class OnboardingState {
  @HiveField(0)
  final bool isSignIn;

  @HiveField(1)
  final bool isAuthCompleted;

  OnboardingState({
    this.isSignIn = false,
    required this.isAuthCompleted,
  });

  OnboardingState copyWith({
    bool? isSignIn,
    bool? isAuthCompleted,
  }) {
    return OnboardingState(
      isSignIn: isSignIn ?? this.isSignIn,
      isAuthCompleted: isAuthCompleted ?? this.isAuthCompleted,
    );
  }

  // default value
  static OnboardingState get initialState => OnboardingState(
        isSignIn: false,
        isAuthCompleted: false,
      );
}
