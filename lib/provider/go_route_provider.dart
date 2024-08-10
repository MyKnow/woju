import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../service/debug_service.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPush: $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPop: $route");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidRemove: $route");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    printd("DidReplace: $newRoute");
  }
}

///
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    observers: [RouterObserver()],
    redirect: (context, state) async {
      return null;
    },
    routes: [],
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
