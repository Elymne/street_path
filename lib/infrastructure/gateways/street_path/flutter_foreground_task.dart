// The callback function should always be a top-level or static function.
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// * Obligé d'utiliser une fonction statique pour le callback lors de démarrage du service.
@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}

/// Classe utilisé par l'implémentation de l'interface StreetPathGateway : StreetPathGatewayImpl
/// Libs : flutter_reactive_ble, flutter_foreground_task
class StreetPathTaskHandler extends TaskHandler {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  /// Cette appel de fonction ne sert pour l'instant juste à log et à tester la librairie.
  /// todo : Check si il y a des choses à regarder.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (kDebugMode) print('StreetPath Service starting at : ${starter.name})');
  }

  /// ! Cette fonction de callback sera appellé à une intervale de temps x défini dans la classe StreetPathGatewayImpl (fonction d'initialisation).
  /// Chaque x intervale de temps : Récupération de tous les devices détecté à proximité (class DiscoveredDevice).
  @override
  void onRepeatEvent(DateTime timestamp) {
    _ble.scanForDevices(withServices: [], scanMode: ScanMode.lowPower).listen((device) {
      if (kDebugMode) print('Device found: ${device.name} (${device.id})');
    });
  }

  /// Permet la connexion à l'appareil rentré en paramètre.
  /// todo : checker si l'appareil à l'app, si elle emet, si elle veut transmettre et veut recevoir.
  Future connectToDevice(DiscoveredDevice device) async {
    late QualifiedCharacteristic characteristic;

    // 1. Connect.
    final connection = _ble.connectToDevice(id: device.id);

    connection.listen((connectionState) async {
      // 2. Définir la caractéristique (tu dois connaître les UUID)
      const serviceUuid = "0000180f-0000-1000-8000-00805f9b34fb";
      const characteristicUuid = "00002a19-0000-1000-8000-00805f9b34fb";

      characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid as Uuid,
        characteristicId: characteristicUuid as Uuid,
        deviceId: device.id,
      );

      // 3. Envoyer des données (ici on envoie un tableau d’octets)
      final payload = [0x01, 0x02, 0x03]; // tes données
      await _ble.writeCharacteristicWithResponse(characteristic, value: payload);

      print("📡 Data sent: $payload");
    });
  }

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
