import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:poc_street_path/core/l10n/app_localizations.dart';
import 'package:poc_street_path/core/themes/light_theme.dart';
import 'package:poc_street_path/app/screens/splash_screen/splash_screen.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    // * Update bottom bar navigation when on android device. Don't know why but the bottom navigation bar stay bright without this.
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: null, systemNavigationBarIconBrightness: Brightness.dark),
      );
    }

    // * This app is only usable on portrait mode.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // * Run the views and styles.
    return MaterialApp(
      title: "POC - Street Path",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      theme: CustomTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
