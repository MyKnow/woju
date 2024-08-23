import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/model/app_state_model.dart';
import 'package:woju/model/onboarding/sign_in_model.dart';
import 'package:woju/page/error/router_error_page.dart';
import 'package:woju/page/error/server_error_page.dart';
import 'package:woju/page/home/home_page.dart';

import 'package:woju/page/onboarding/onboarding_page.dart';
import 'package:woju/page/onboarding/signin_page.dart';
import 'package:woju/page/onboarding/signup_page.dart';
import 'package:woju/page/onboarding/signup_userinfo_page.dart';
import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/service/debug_service.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPush: $previousRoute -> $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPop: $route -> $previousRoute");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidRemove: $route -> $previousRoute");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    printd("DidReplace: $oldRoute -> $newRoute");
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final signInStatus =
      ref.watch(appStateProvider.select((state) => state.signInStatus));
  final errorState =
      ref.watch(appStateProvider.select((state) => state.appError));
  return GoRouter(
    initialLocation: '/',
    observers: [RouterObserver()],
    errorPageBuilder: (context, state) {
      return const NoTransitionPage(child: RouterErrorPage());
    },
    redirect: (context, state) {
      // 현재 경로가 null이라면 null 반환
      if (state.fullPath == null || state.fullPath == '') {
        return null;
      }

      // null이 아니라면 상태를 확인하여 리다이렉트
      final nowPath = state.fullPath as String;
      // 현재 경로
      printd("Current Path: $nowPath");

      if (errorState == AppError.serverError) {
        return '/error/server';
      } else if (errorState == AppError.autoSignInError) {
        return '/onboarding/signin';
      }

      // 로그인 상태가 아닐 때
      if (signInStatus != SignInStatus.loginSuccess) {
        // 온보딩 하위 경로에 있지 않다면 온보딩으로 리다이렉트
        if (!nowPath.contains('/onboarding')) {
          return '/onboarding';
        }
      } else {
        // 온보딩 하위 경로에 있다면 홈으로 리다이렉트
        if (nowPath.contains('/onboarding')) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      _buildNoTransitionRoute(
        path: '/',
        builder: (context, state) {
          return const HomePage();
        },
        text: '홈',
      ),
      _buildNestedRoute(
        path: '/onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
        text: '온보딩',
        routes: [
          _buildNestedRoute(
            path: 'signup',
            builder: (context, state) {
              return const SignUpPage();
            },
            text: '회원가입',
            routes: [
              _buildNoTransitionRoute(
                path: 'detail',
                builder: (context, state) {
                  return const SignupUserinfoPage();
                },
                text: '회원가입 상세',
              ),
            ],
          ),
          _buildNoTransitionRoute(
            path: 'signin',
            builder: (context, state) {
              return const SignInPage();
            },
            text: '로그인',
          ),
        ],
      ),
      _buildNestedRoute(
        path: '/error',
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text('에러 페이지'),
            ),
          );
        },
        text: '에러',
        routes: [
          _buildNoTransitionRoute(
            path: 'server',
            builder: (context, state) {
              return const ServerErrorPage();
            },
            text: '서버 에러',
          ),
        ],
      ),
    ],
  );
});

GoRoute _buildNoTransitionRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return NoTransitionPage(child: builder(context, state));
    },
  );
}

GoRoute _buildCustomTransitionRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return CustomTransitionPage(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: builder(context, state),
      );
    },
  );
}

GoRoute _buildNestedRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
  required List<GoRoute> routes,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return NoTransitionPage(child: builder(context, state));
    },
    routes: routes,
  );
}
