import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNotifier = ref.watch(signInStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: signInNotifier.withdrawalButtonOnClick(context),
              child: const Text("Withdrawal"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(signInStateProvider.notifier).logout();
              },
              child: const Text("Sign Out"),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/onboarding');
              },
              child: const Text("Go to Onboarding"),
            ),
          ],
        ),
      ),
    );
  }
}
