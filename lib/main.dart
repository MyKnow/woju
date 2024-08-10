import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/app_state_model.dart';
import 'package:woju/model/hive_box_enum.dart';

import 'provider/app_state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Hive.registerAdapter(OnboardingStateAdapter()); // 생성된 어댑터 등록

  for (var box in HiveBox.values) {
    box.registerAdapter();
    await box.openBox();
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(onboardingState.isCompleted ? 'Completed' : 'Not Completed'),
            ElevatedButton(
              onPressed: () {
                ref.read(onboardingStateProvider.notifier).update(
                      OnboardingState(
                          isCompleted: true, isAlreadyOnboarded: true),
                    );
              },
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
