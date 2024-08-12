// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/page/onboarding/onboarding_page.dart';
import 'package:woju/page/onboarding/signin_page.dart';
import 'package:woju/page/onboarding/signup_page.dart';
import 'package:woju/provider/onboarding/onboarding_state_notifier.dart';
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
  final onboardingState = ref.watch(onboardingStateProvider);
  return GoRouter(
    initialLocation: '/',
    observers: [RouterObserver()],
    redirect: (context, state) {
      // 로그인이 되어있지 않고, 온보딩이 되어있지 않다면 온보딩 페이지로 이동
      if (!onboardingState.isAlreadyOnboarded && !onboardingState.isSignIn) {
        return '/onboarding';
      }

      // 온보딩은 완료되었지만 로그인이 되어있지 않다면
      if (onboardingState.isAlreadyOnboarded && !onboardingState.isSignIn) {
        // 로그인 페이지로 이동하는 경우
        if (onboardingState.gotoSignIn) {
          return '/onboarding/signin';
        }
        // 회원가입 페이지로 이동하는 경우
        return '/onboarding/signup';
      }

      return null;
    },
    routes: [
      _buildNoTransitionRoute(
        path: '/',
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                  onPressed: () {
                    ref.read(onboardingStateProvider.notifier).delete();
                  },
                  child: Text("Delete Onboarding State")),
            ),
          );
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
          _buildNoTransitionRoute(
            path: 'signup',
            builder: (context, state) {
              return const SignUpPage();
            },
            text: '회원가입',
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
