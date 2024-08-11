import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/hive_box_enum.dart';

import 'provider/go_route_provider.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      darkTheme: ThemeData.dark(useMaterial3: false),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
