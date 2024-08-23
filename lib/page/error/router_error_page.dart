import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouterErrorPage extends ConsumerWidget {
  const RouterErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('error.router.title').tr(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('error.router.button').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
