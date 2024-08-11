import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/page/onboarding/onboarding_page.dart';

import '../service/debug_service.dart';
import 'app_state_notifier.dart';

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
      if (!onboardingState.isAlreadyOnboarded) {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      _buildNoTransitionRoute(
        path: '/',
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text('Home Page'),
            ),
          );
        },
        text: 'Home',
      ),
      _buildNestedRoute(
        path: '/onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
        text: 'Onboarding',
        routes: [
          _buildNoTransitionRoute(
            path: 'step1',
            builder: (context, state) {
              return const Scaffold(
                body: Center(
                  child: Text('Onboarding Step 1'),
                ),
              );
            },
            text: 'Onboarding Step 1',
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
