import 'package:flutter/material.dart';

import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:woju/firebase_options.dart';
import 'package:woju/model/hive_box_enum.dart';
import 'package:woju/provider/go_route_provider.dart';
import 'package:woju/provider/theme_state_notififer.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/theme/custom_theme_data.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  for (var box in HiveBox.values) {
    box.registerAdapter();
  }
  for (var box in HiveBox.values) {
    await box.openBox();
  }

  final naverMapClientID = dotenv.get('NAVER_MAP_CLIENT_ID');

  printd('NAVER_MAP_CLIENT_ID: $naverMapClientID');

  await NaverMapSdk.instance.initialize(
    clientId: naverMapClientID,
    onAuthFailed: (ex) {
      printd(ex);
    },
  );

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko', 'KR'),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      builder: (context, child) => AccessibilityTools(
        logLevel: LogLevel.none,
        child: child,
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      darkTheme: CustomThemeData.dark,
      themeMode: ref.watch(themeStateNotifierProvider),
      theme: CustomThemeData.light,
      routerConfig: ref.watch(goRouterProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
