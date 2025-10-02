import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:poc_street_path/presentation/screens/splash_screen/splash_screen.dart';
import 'package:poc_street_path/core/l10n/app_localizations.dart';
import 'package:poc_street_path/core/themes/light_theme.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "POC - Street Path",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale("fr"),
      theme: CustomTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
