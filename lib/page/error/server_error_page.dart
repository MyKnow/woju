import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/app_state_notifier.dart';

class ServerErrorPage extends ConsumerWidget {
  const ServerErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStatusNotifier = ref.watch(appStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('error.server.title').tr(),
        leading: const SizedBox(),
      ),
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const Text('error.server.description').tr(),
            ElevatedButton(
              onPressed: () async {
                await appStatusNotifier.checkServerConnection();
              },
              child: const Text('error.server.retry').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
