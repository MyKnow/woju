import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/model/onboarding/sign_in_model.dart';

import '../model/app_state_model.dart';

/// ### 온보딩 상태를 관리하는 StateNotifier
///
/// Hive를 사용하여 온보딩 상태를 저장하고 업데이트합니다.
///
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) {
    return AppStateNotifier();
  },
);

class AppStateNotifier extends StateNotifier<AppState> {
  // 초기 상태를 불러오거나 기본값을 설정
  AppStateNotifier() : super(AppState.initialState);

  /// ### 로그인 상태 업데이트
  ///
  /// 로그인 상태를 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [SignInStatus] isSignIn: 로그인 상태
  ///
  void updateSignInStatus(SignInStatus isSignIn) {
    state = state.copyWith(isSignIn: isSignIn);
  }

  /// ### 부팅 완료 상태 업데이트
  ///
  /// 부팅 완료 상태를 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [bool] bootComplete: 부팅 완료 상태
  ///
  void updateBootComplete(bool bootComplete) {
    state = state.copyWith(isBootComplete: bootComplete);
  }

  /// ### 에러 상태 업데이트
  ///
  /// 에러 상태를 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [AppError] appError: 에러 상태
  ///
  void updateAppError(AppError appError) {
    state = state.copyWith(appError: appError);
  }

  /// ### AppState 반환
  ///
  /// 현재 AppState를 반환합니다.
  ///
  /// #### Return
  ///
  /// - [AppState] : 현재 AppState
  ///
  AppState get onboardingState => state;
}

/// AppStateNotifier를 위한 Action을 정의한 확장
///
extension AppStateAction on AppStateNotifier {
  /// ### Sign In 페이지로 이동
  ///
  /// 온보딩을 완료하고 Sign In 페이지로 이동합니다.
  ///
  void pushRouteSignInPage(BuildContext context) {
    context.push('/onboarding/signin');
  }

  /// ### SignUp 페이지로 이동
  ///
  /// 온보딩을 완료하고 SignUp 페이지로 이동합니다.
  ///
  void pushRouteSignUpPage(BuildContext context) {
    context.push('/onboarding/signup');
  }

  /// ### SignUp에서 인증을 완료하고 세부 정보 입력 페이지로 이동
  ///
  /// SignUp에서 인증을 완료하고 세부 정보 입력 페이지로 이동합니다.
  ///
  /// #### Parameters
  ///
  /// - [BuildContext] context: BuildContext
  ///
  void pushRouteSignUpDetailPage(BuildContext context) {
    context.push('/onboarding/signup/detail');
  }
}
