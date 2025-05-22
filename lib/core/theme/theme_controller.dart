import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTheme {
  final ThemeMode mode;
  final Color primaryColor;
  final String fontFamily;

  const AppTheme({
    required this.mode,
    required this.primaryColor,
    required this.fontFamily,
  });

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier()
      : super(const AppTheme(
          mode: ThemeMode.light,
          primaryColor: Colors.blue,
          fontFamily: 'Roboto',
        ));

  void toggleTheme(bool isDark) {
    state = AppTheme(
      mode: isDark ? ThemeMode.dark : ThemeMode.light,
      primaryColor: state.primaryColor,
      fontFamily: state.fontFamily,
    );
  }

  void updatePrimaryColor(Color color) {
    state = AppTheme(
      mode: state.mode,
      primaryColor: color,
      fontFamily: state.fontFamily,
    );
  }

  void updateFontFamily(String font) {
    state = AppTheme(
      mode: state.mode,
      primaryColor: state.primaryColor,
      fontFamily: font,
    );
  }
}
