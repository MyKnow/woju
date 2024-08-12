import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/onboarding/onboarding_state_notifier.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(onboardingStateProvider.notifier).update(
                  ref.read(onboardingStateProvider).copyWith(isSignIn: true),
                );
          },
          child: const Text("Sign In"),
        ),
      ),
    );
  }
}
