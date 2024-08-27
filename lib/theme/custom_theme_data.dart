import 'package:flutter/material.dart';

class CustomThemeData {
  static final ThemeData light = ThemeData(
    useMaterial3: false,
    cardTheme: const CardTheme(
      color: Colors.white,
      shadowColor: Colors.black38,
      surfaceTintColor: Colors.black,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue[900],
    cardColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: Colors.blue[900],
      errorColor: Colors.red,
      cardColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[100],
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.black),
      actionTextColor: Colors.blue[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    primaryTextTheme: TextTheme(
      titleMedium: textTheme.titleMedium?.copyWith(color: Colors.black),
      bodyMedium: textTheme.bodyMedium?.copyWith(color: Colors.black),
      bodyLarge: textTheme.bodyLarge?.copyWith(color: Colors.black),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.black),
      iconTheme: const IconThemeData(color: Colors.black),
      shadowColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.labelSmall?.copyWith(color: Colors.black),
      labelStyle: textTheme.bodySmall?.copyWith(color: Colors.black),
      errorStyle: textTheme.labelMedium?.copyWith(color: Colors.red),
      iconColor: Colors.blue[900],
      prefixIconColor: Colors.blue[900],
      suffixIconColor: Colors.blue[900],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          textTheme.bodyMedium?.copyWith(color: Colors.blue[900]),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.blue[900]),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue[900],
      selectionColor: Colors.blue[100],
      selectionHandleColor: Colors.blue[100],
    ),
    shadowColor: Colors.black38,
    iconTheme: IconThemeData(color: Colors.blue[900]),
    disabledColor: Colors.grey[500],
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: false,
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 22, 22, 22),
      shadowColor: Colors.grey[100],
      surfaceTintColor: Colors.white,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.purple,
    cardColor: const Color.fromARGB(255, 22, 22, 22),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.purple,
      accentColor: Colors.purple,
      errorColor: Colors.red,
    ),
    primaryTextTheme: TextTheme(
      titleMedium: textTheme.titleMedium?.copyWith(color: Colors.white),
      bodyMedium: textTheme.bodyMedium?.copyWith(color: Colors.white),
      bodyLarge: textTheme.bodyLarge?.copyWith(color: Colors.white),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[900],
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      actionTextColor: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      shadowColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
      labelStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      errorStyle: textTheme.labelMedium?.copyWith(color: Colors.red),
      iconColor: Colors.purple,
      prefixIconColor: Colors.purple,
      suffixIconColor: Colors.purple,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          textTheme.bodySmall?.copyWith(
            color: Colors.black,
          ),
        ),
        iconColor: WidgetStateProperty.all(
          Colors.black,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          textTheme.bodyLarge?.copyWith(color: Colors.purple),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.purple),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.purple,
      selectionColor: Colors.purple[100],
      selectionHandleColor: Colors.purple[100],
    ),
    shadowColor: Colors.grey[700],
    iconTheme: const IconThemeData(color: Colors.purple),
    disabledColor: Colors.grey[500],
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
    displayMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
    displaySmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
    headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
    headlineMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
    headlineSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    titleSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
    bodyLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    bodySmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
    labelLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    labelMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    labelSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
  );

  // 현재 system theme에 따라서 light 또는 dark를 반환
  static ThemeData get currentTheme {
    if (ThemeMode.system == ThemeMode.dark) {
      return CustomThemeData.dark;
    }
    return CustomThemeData.light;
  }

  static bool get isDark => currentTheme == dark;
}
