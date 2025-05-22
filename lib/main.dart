import 'package:data_theme_app/features/offline_data/services/sync_service.dart';
import 'package:data_theme_app/features/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('localData');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeNotifierProvider);
    startBackgroundSync();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: appTheme.mode,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
