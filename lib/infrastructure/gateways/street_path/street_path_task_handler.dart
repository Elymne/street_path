import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:poc_street_path/core/globals.dart';
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
  late final NearbyService _nearbySevice = NearbyService();

  // * Utilisé pour réduire la consommation énergétique de l'app. technique : http://iot-strasbourg.strataggem.com/ref/duty-cycle.html
  late final Timer dutyCycler;

  // ? Listener de tous les changements d'état
  late final StreamSubscription _subscription;
  late final StreamSubscription _receivedDataSubscription;

  // todo : Actuellement géré juste en mémoire. Surement une idée de con.
  final List<_Seen> _seens = [];

  // todo : data à envoyer lorsqu'on rencontre d'autres personnes. Cette classe ne devrait jamais pouvoir communiquer avec la DB. Je veux que ce truc soit limite Agnostique du reste de l'app.
  // todo : Ca veut dire qu'on va devoir possiblement store en RAM de la data (Object pour l'instant mais ça sera soit du JSON ou un truc opti pour transférer la data de la manière la plus légère).
  Object? jsonPostsToSend;

  /// Cette appel de fonction ne sert pour l'instant juste à log et à tester la librairie.
  /// todo : Check si il y a des choses à regarder.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // * Initialisation du service WIFI/BLE (NearbyService).
    // * Le nom de l'appareil sera toujours randomisé, l'outil est pour l'instant anonyme.
    if (kDebugMode) print('StreetPath Service starting…');
    await _nearbySevice.init(
      serviceType: 'com.cyneila.streetpath',
      strategy: Strategy.P2P_CLUSTER,
      deviceName: '$streetPathSignatureName:${Uuid().v4()}',
      callback: (dynamic _) async {
        if (kDebugMode) print('StreetPath Service has started.');
      },
    );

    // * Callback de détection de changement au niveau du WIFI/BLE.
    // * C'est ici qu'on gère les transferts de data.
    _subscription = _nearbySevice.stateChangedSubscription(
      callback: (devicesList) {
        final seensId = _seens.map((elem) => elem.deviceId);
        for (final device in devicesList) {
          // * Si déjà vu, on skip.
          if (seensId.contains(device.deviceId)) {
            continue;
          }

          final signature = device.deviceName.split(":")[0];
          // * On skip si ça provient pas d'un appareil avec l'app.
          if (signature != streetPathSignatureName) {
            _seens.add(_Seen(deviceId: device.deviceId, at: DateTime.now().millisecondsSinceEpoch));
            continue;
          }

          // * If not connected, invite him.
          if (device.state == SessionState.notConnected) {
            _nearbySevice.invitePeer(deviceID: device.deviceId, deviceName: device.deviceName);
            continue;
          }

          // todo : Je pourrais faire quoi ici ? Changer la notif ? J'sais pas, à voir.
          if (device.state == SessionState.connecting) {
            continue;
          }

          // * Connected, share data and skip him next time.
          // todo : Si erreur, on skip quand même, à voir comment ça devrait réagir.
          if (device.state == SessionState.connected) {
            _nearbySevice.sendMessage(device.deviceId, 'This is a dumb message.');
            _seens.add(_Seen(deviceId: device.deviceId, at: DateTime.now().millisecondsSinceEpoch));
            continue;
          }

          if (kDebugMode) {
            print(" deviceId: ${device.deviceId} | deviceName: ${device.deviceName} | state: ${device.state}");
          }
        }
      },
    );

    // * Detection des transfert de data.
    _receivedDataSubscription = _nearbySevice.dataReceivedSubscription(
      callback: (data) {
        if (kDebugMode) {
          print("Data fetched from device : ${jsonEncode(data)}");
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

  /// todo : Je vais utiliser cette fonction pour remplir dans une sorte de cache les Posts que je souhaites envoyer ou non.
  /// Je ne peux absolument pas que cette classe fasse de la logique métier. Les Posts choisies, c'est plus haut.
  /// Même chose pour la data sauvegardé. On envoie la data non parsé comme des sales jusqu'en haut et basta.
  @override
  void onReceiveData(Object data) {}

  /// * Jamais call actuellement.
  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// Le service a été cancel, détruit, soit par l'utilisateur, soit par un crash de l'app, soit par la fermeture complète de l'app.
  /// Par sécurité, on cancel alors tout les listeners.
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
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}

class _Seen {
  final String deviceId;
  final int at;
  _Seen({required this.deviceId, required this.at});
}
