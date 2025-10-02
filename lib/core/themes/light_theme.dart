import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFFFF4164),
  onPrimary: Color(0xFFF0F0F0),

  secondary: Color.fromARGB(255, 59, 255, 206),
  onSecondary: Color(0xFFF0F0F0),

  error: Color(0xFFFF0000),
  onError: Color(0xFFFFFFFF),

  surface: Color.fromARGB(255, 245, 243, 242),
  surfaceContainer: Color.fromARGB(255, 255, 255, 255),
  onSurface: Color(0xFF3A3A3A),
  onSurfaceVariant: Color(0xFF888888),

  outline: Color(0xFF3A3A3A),
  outlineVariant: Color(0xFF888888),
  shadow: Color(0x7E3A3A3A),
);

final lightTextTheme = TextTheme(
  /// * SplashScreen Title. (7x7)
  displayLarge: TextStyle(color: lightColorScheme.onSurface, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 0),

  /// * Page screen title. (On dark surface always). (6x6)
  headlineLarge: TextStyle(color: lightColorScheme.onSurface, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 0, height: 1.2),

  /// * Page screen subtitle. (On dark surface always).
  headlineMedium: TextStyle(color: lightColorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: 0, height: 1.2),

  /// * Card Title.
  headlineSmall: TextStyle(color: lightColorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: 0),

  /// * Title for each body section.
  titleLarge: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20),

  /// ! (Not USED)
  titleMedium: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),

  /// ! (Not USED)
  titleSmall: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),

  /// * Main content text.
  bodyLarge: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 16),

  /// * Secondary content text.
  bodyMedium: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 14),

  /// ! (Not USED)
  bodySmall: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 12),

  /// * Button Text.
  labelLarge: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),

  /// ! (Not USED)
  labelMedium: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.normal),

  /// ! (Not USED)
  labelSmall: TextStyle(color: lightColorScheme.onSurface, fontWeight: FontWeight.w100),
);

/// What's this does : manage theming color and text style only.
/// What's this does not : manage button, inputs, navbar style, it's ony about color and text, adn that is all.
class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: lightColorScheme.surface,

      /// * Link Button.
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: lightColorScheme.primary)),

      /// ! Floating Button (Not Used).
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: lightColorScheme.primary),

      /// ! NOT INPUT STYLE.
      textSelectionTheme: TextSelectionThemeData(cursorColor: lightColorScheme.primary),
    );
  }
}
