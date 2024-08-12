import 'package:hive_flutter/hive_flutter.dart';

part 'app_state_model.g.dart';

@HiveType(typeId: 0)
class OnboardingState {
  @HiveField(0)
  final bool isAlreadyOnboarded;

  @HiveField(1)
  final bool isSignIn;

  @HiveField(2)
  final bool gotoSignIn;

  OnboardingState({
    required this.isAlreadyOnboarded,
    this.isSignIn = false,
    required this.gotoSignIn,
  });

  OnboardingState copyWith({
    bool? isAlreadyOnboarded,
    bool? isSignIn,
    bool? gotoSignIn,
  }) {
    return OnboardingState(
      isAlreadyOnboarded: isAlreadyOnboarded ?? this.isAlreadyOnboarded,
      isSignIn: isSignIn ?? this.isSignIn,
      gotoSignIn: gotoSignIn ?? this.gotoSignIn,
    );
  }

  // default value
  static OnboardingState get initialState => OnboardingState(
        isAlreadyOnboarded: false,
        gotoSignIn: false,
        isSignIn: false,
      );
}
