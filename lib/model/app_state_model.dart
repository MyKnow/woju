import 'package:woju/model/onboarding/sign_in_model.dart';

enum AppError {
  none,
  bootError,
  autoSignInError,
}

class AppState {
  final SignInStatus signInStatus;
  final bool isBootComplete;
  final AppError appError;

  AppState({
    this.signInStatus = SignInStatus.logout,
    this.isBootComplete = false,
    this.appError = AppError.none,
  });

  AppState copyWith({
    SignInStatus? isSignIn,
    bool? isBootComplete,
    AppError? appError,
  }) {
    return AppState(
      signInStatus: isSignIn ?? this.signInStatus,
      isBootComplete: isBootComplete ?? this.isBootComplete,
      appError: appError ?? this.appError,
    );
  }

  // default value
  static AppState get initialState => AppState();
}
