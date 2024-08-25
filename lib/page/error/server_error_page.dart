import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/theme/widget/custom_text.dart';

class ServerErrorPage extends ConsumerWidget {
  const ServerErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStatusNotifier = ref.watch(appStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('error.server.title'),
        leading: const SizedBox(),
      ),
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const CustomText('error.server.description'),
            ElevatedButton(
              onPressed: () async {
                await appStatusNotifier.checkServerConnection();
              },
              child: const CustomText('error.server.retry'),
            ),
          ],
        ),
      ),
    );
  }
}
