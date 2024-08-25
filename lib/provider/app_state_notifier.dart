import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/service/secure_storage_service.dart';

import '../model/app_state_model.dart';

/// ### 앱 전반의 상태를 관리하는 StateNotifier
///
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) {
    return AppStateNotifier(ref);
  },
);

class AppStateNotifier extends StateNotifier<AppState> {
  late final Ref ref;
  AppStateNotifier(this.ref) : super(AppState.initialState) {
    // login
    initialBoot();
  }

  /// ### 로그인 상태 업데이트
  ///
  /// 로그인 상태를 업데이트합니다.
  ///
  /// #### Parameters
  ///
  /// - [SignInStatus] isSignIn: 로그인 상태
  ///
  void updateSignInStatus(SignInStatus signInStatus) {
    state = state.copyWith(signInStatus: signInStatus);
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
  AppState get appState => state;
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

  /// ### 초기 부팅 메소드
  ///
  /// #### Notes
  ///
  /// - 아직 bootComplete가 false인 상태에서만 실행
  /// - autoSignIn을 시도하고, 성공하면 로그인 상태를 업데이트하고, 실패하면 에러 상태를 업데이트
  /// - bootComplete를 true로 업데이트
  ///
  Future<void> initialBoot() async {
    printd("initialBoot");
    if (appState.isBootComplete) {
      FlutterNativeSplash.remove();
      return;
    }

    // autoSignIn을 시도하고, 성공하면 로그인 상태를 업데이트하고, 실패하면 에러 상태를 업데이트
    final result = await UserService.autoSignIn(ref);

    printd("initialBoot : AutoLogin result: $result");

    // 로그인 성공 시 홈으로 이동해야 함
    if (result == SignInStatus.loginSuccess) {
      updateSignInStatus(result);
      updateAppError(AppError.none);
    }
    // 서버 오류 시 에러 화면으로 이동해야 함
    else if (result == SignInStatus.loginFailedForServer) {
      updateSignInStatus(SignInStatus.logout);
      updateAppError(AppError.serverError);
    }
    // 로그인 정보가 없을 시 온보딩으로 이동해야 함
    else if (result == SignInStatus.logout) {
      updateSignInStatus(SignInStatus.logout);
      updateAppError(AppError.none);
    } // 그 외의 경우 (로그인 실패)
    else {
      updateSignInStatus(SignInStatus.logout);
      await ref.read(userDetailInfoStateProvider.notifier).delete();
      await SecureStorageService.deleteSecureData(SecureModel.userPassword);
      updateAppError(AppError.autoSignInError);
    }

    updateBootComplete(true);
    FlutterNativeSplash.remove();
  }

  /// ### 서버 연결 상태 확인 메소드
  ///
  /// 서버 연결 상태를 확인합니다.
  ///
  /// #### Return
  ///
  /// - [bool] : 서버 연결 상태
  ///
  Future<bool> checkServerConnection() async {
    final result =
        await HttpService.get('/api/service/check-connection-status');

    if (result.statusCode == 200) {
      updateAppError(AppError.none);
      return true;
    } else {
      updateAppError(AppError.serverError);
      return false;
    }
  }
}
