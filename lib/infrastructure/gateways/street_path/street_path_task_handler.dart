// The callback function should always be a top-level or static function.
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:uuid/uuid.dart';

// * Obligé d'utiliser une fonction statique pour le callback lors de démarrage du service.
@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}

/// Classe utilisé par l'implémentation de l'interface StreetPathGateway : StreetPathGatewayImpl
/// Comporte une liste de callback de la classe TaskHandler pour créer un service qui tourne en background.
/// C'est elle qui va s'occuper de récupérer les appareils proches détectés.
/// Libs : flutter_foreground_task, flutter_nearby_connections.
class StreetPathTaskHandler extends TaskHandler {
  late final NearbyService _nearbySevice;

  /// * Utilisé pour réduire la consommation énergétique de l'app. technique : http://iot-strasbourg.strataggem.com/ref/duty-cycle.html
  late final Timer dutyCycler;

  /// ? Listener de tous les changements d'état
  late final StreamSubscription _subscription;
  late final StreamSubscription _receivedDataSubscription;

  /// * Listener des changements d'écoutes de devices, caneaux, etc.

  /// Cette appel de fonction ne sert pour l'instant juste à log et à tester la librairie.
  /// todo : Check si il y a des choses à regarder.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // * Initialisation du service WIFI/BLE (NearbyService).
    if (kDebugMode) print('StreetPath Service starting…');
    _nearbySevice = NearbyService();
    await _nearbySevice.init(
      serviceType: 'com.cyneila.streetpath',
      strategy: Strategy.P2P_CLUSTER,
      deviceName: Uuid().v4(),
      callback: (isRunning) async {},
    );
    if (kDebugMode) print('StreetPath Service has started.');

    // * Détection des nouveaux appareils.
    _subscription = _nearbySevice.stateChangedSubscription(
      callback: (devicesList) {
        for (final element in devicesList) {
          if (kDebugMode) {
            print(" deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
          }
        }
      },
    );

    // * Detection des transfert de data.
    _receivedDataSubscription = _nearbySevice.dataReceivedSubscription(
      callback: (data) {
        if (kDebugMode) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
        }
      },
    );

    // * Duty Cycler classique.
    dutyCycler = Timer.periodic(Duration(seconds: 30), (timer) async {
      _nearbySevice.startBrowsingForPeers();
      _nearbySevice.startAdvertisingPeer();
      Future.delayed(Duration(seconds: 5), () {
        _nearbySevice.stopBrowsingForPeers();
        _nearbySevice.stopAdvertisingPeer();
      });
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _nearbySevice.stopBrowsingForPeers();
    await _nearbySevice.stopAdvertisingPeer();
    await Future.wait([_subscription.cancel(), _receivedDataSubscription.cancel()]);
    dutyCycler.cancel();

    if (kDebugMode) {
      print('StreetPath Service closed');
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}
