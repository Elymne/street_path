// Copyright 2025 Sacha Djurdjevic
// Licensed under the Apache License, Version 2.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:poc_street_path/application/app.dart';

Future main() async {
  await initializeDateFormatting('fr_FR', null);
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  runApp(ProviderScope(child: const App()));
}
