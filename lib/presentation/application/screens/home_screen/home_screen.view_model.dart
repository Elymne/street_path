import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenViewModel extends AsyncNotifier<HomeScreenDisplay> {
  @override
  FutureOr<HomeScreenDisplay> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> checkData() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(HomeScreenDisplay(10, 'Données vérifiées'));
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

class HomeScreenDisplay {
  final int progress;
  final String message;
  HomeScreenDisplay(this.progress, this.message);
}
