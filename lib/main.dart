// Copyright 2024 Sacha Djurdjevic
// Licensed under the Apache License, Version 2.0

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:poc_street_path/presentation/application/mobile_app.dart';
import 'package:poc_street_path/presentation/application/web_app.dart';

Future main() async {
  await Future.wait([initializeDateFormatting("fr_FR", null), dotenv.load(fileName: ".env")]);
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;

  if (kIsWeb) {
    runApp(ProviderScope(child: const WebApp()));
    return;
  }

  runApp(ProviderScope(child: const MobileApp()));
}
