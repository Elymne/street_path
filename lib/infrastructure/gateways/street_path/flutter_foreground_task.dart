// The callback function should always be a top-level or static function.
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// * Obligé d'utiliser une fonction statique pour le callback lors de démarrage du service.
@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}

/// Classe utilisé par l'implémentation de l'interface StreetPathGateway : StreetPathGatewayImpl
/// Libs : flutter_reactive_ble, flutter_foreground_task
class StreetPathTaskHandler extends TaskHandler {
  /// Cette appel de fonction ne sert pour l'instant juste à log et à tester la librairie.
  /// todo : Check si il y a des choses à regarder.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (kDebugMode) print('StreetPath Service starting at : ${starter.name})');
  }

  /// ! Cette fonction de callback sera appellé à une intervale de temps x défini dans la classe StreetPathGatewayImpl (fonction d'initialisation).
  /// Chaque x intervale de temps : Récupération de tous les devices détecté à proximité (class DiscoveredDevice).
  @override
  void onRepeatEvent(DateTime timestamp) {}

  // ----------------------------------
  // -- NON USED
  // ----------------------------------

  /// Détruire la co BLE imo.
  /// todo : Destruction de tout ce qui concerne les outils BLE.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    if (kDebugMode) print('onDestroy(isTimeout: $isTimeout)');
  }

  @override
  void onReceiveData(Object data) {
    if (kDebugMode) print('onReceiveData: $data');
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}
