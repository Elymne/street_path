import 'package:nearby_service/nearby_service.dart';
import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/domain/usecases/sync/add_raw_data.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';

/// ! Riverpod est inutilisable dans ce contexte : vous ne pouvez pas utiliser de Provider !
/// ! J'ai mal compris le fonctionnement du WIFI car je suis con. Il ne peut bien évidement n'y avoir qu'une seule connexion à la fois.
class NearbyServiceImpl {
  late final NearbyService _nearbyService = NearbyService.getInstance();

  late final _pathProviderGatewayImpl = PathProviderGatewayImpl();
  late final _databaseGateway = ObjectBoxGateway(_pathProviderGatewayImpl);
  late final _rawDataRepository = RawDataRepositoryImpl(_databaseGateway);
  late final _addRawData = AddRawData(_rawDataRepository);

  late final Timer dutyCycler; // *  http://iot-strasbourg.strataggem.com/ref/duty-cycle.html

  late final NearbyServiceMessagesListener _nearbyServiceMessageListener;
  late Null _connectedDevice = null;
  final List<_SeenDevice> _seenDevices = [];

  String _shareableData = jsonEncode([]); // * Data à share.

  NearbyServiceImpl();

  void setShareableData(String contentData) {
    _shareableData = contentData;
  }

  /// Simple vérification des permissions Android et du statut du WIFI.
  /// J'en ai besoin pour être sûr que je peux démarrer l'écoute des appareils à proximité.
  Future<bool> check() async {
    SpLog().i('StreetPath scan starting…');
    await _nearbyService.initialize();

    final granted = await _nearbyService.android?.requestPermissions() ?? false;
    if (granted == false) {
      return false;
    }

    final isWifiEnabled = await _nearbyService.android?.checkWifiService() ?? false;
    if (isWifiEnabled == false) {
      return false;
    }

    SpLog().i('StreetPath initialised.');
    return true;
  }

  /// Fait pas mal de trucs :
  /// - Commence l'écoutes les changements lorsque des appareils avec le BLE/WIFI d'activité sont détecté par l'appareil.
  /// - Tentes des connections sur les appareils reconnu.
  /// - Tentes de transférer de la data sur les appareils reconnu et connecté.
  ///
  /// Si il s'avère que l'écoute ne peut pas être lancé, on retourne false pour permettre à mon service de relancer ou non la détection.
  Future<bool> start() async {
    // * Démarre impossible, problème lié au check au dessus.
    if (await _nearbyService.discover() == false) {
      return false;
    }

    // * Ecoute des appareils à côté.
    _nearbyService.getPeersStream().listen((event) async {
      // * On a juste besoin des ids identifiés précédement.
      final seensId = _seenDevices.map((elem) => elem.deviceId);

      for (final device in event) {
        SpLog().i(
          'Device WIFI/BLE detected : deviceId: ${device.info.id} | deviceName: ${device.info.displayName} | state: }',
        );

        if (seensId.contains(device.info.id)) {
          continue; // * Déjà vu, on skip.
        }

        if (device.status == NearbyDeviceStatus.connecting) {
          continue; // * En cours de connexion, on skip en attendant le prochain event.
        }

        final signature = device.info.displayName.split(':')[0];
        if (signature != streetPathSignatureName) {
          _seenDevices.add(_SeenDevice(deviceId: device.info.id, at: DateTime.now().millisecondsSinceEpoch));
          continue; // * Mauvaise signature. On ajoute aux déjà vu et on skip.
        }

        if (device.status == NearbyDeviceStatus.available) {
          if (await _nearbyService.connectById(device.info.id) == false) {
            _seenDevices.add(_SeenDevice(deviceId: device.info.id, at: DateTime.now().millisecondsSinceEpoch));
            continue; // * On n'a pas réussi à se connecter. On retentera une prochaine fois.
          }
        }

        if (device.status == NearbyDeviceStatus.connected) {
          _nearbyService.send(
            OutgoingNearbyMessage(
              content: NearbyMessageTextRequest.create(value: _shareableData),
              receiver: device.info,
            ),
          );
          _seenDevices.add(_SeenDevice(deviceId: device.info.id, at: DateTime.now().millisecondsSinceEpoch));
          continue; // * Content envoyé, on se barre.
        }
      }
    });

    // * Reception de data.
    _nearbyServiceMessageListener = NearbyServiceMessagesListener(
      onData: (message) {
        if (message.content is NearbyMessageTextRequest) {
          SpLog().i('New Data received from ${message.sender.id}');

          _addRawData.execute(AddRawDataParams(jsonEncode(message.content)));
          _nearbyService.send(
            OutgoingNearbyMessage(receiver: message.sender, content: NearbyMessageTextResponse(id: message.content.id)),
          );
          return;
        }

        if (message.content is NearbyMessageTextResponse) {}
      },
    );

    // _connectedDeviceSubscription = _nearbyService.getConnectedDeviceStreamById(deviceId).listen((event) async {
    //   final wasConnected = connectedDevice?.status.isConnected ?? false;
    //   final nowConnected = event?.status.isConnected ?? false;
    //   if (wasConnected && !nowConnected) {
    //     // return to the discovery state
    //   }
    //   connectedDevice = event;
    // });

    // * Duty Cycler.
    // dutyCycler = Timer.periodic(Duration(seconds: 30), (timer) async {
    //   _nearbySevice.startBrowsingForPeers();
    //   _nearbySevice.startAdvertisingPeer();
    //   Future.delayed(Duration(seconds: 5), () {
    //     _nearbySevice.stopBrowsingForPeers();
    //     _nearbySevice.stopAdvertisingPeer();
    //   });
    // });
    return true;
  }

  // Future stop() async {
  //   await _nearbySevice.stopBrowsingForPeers();
  //   await _nearbySevice.stopAdvertisingPeer();
  //   await Future.wait([_subscription.cancel(), _nearbyServiceMessageListener.cancel()]);
  //   dutyCycler.cancel();
  // }
}

class _SeenDevice {
  final String deviceId;
  final int at;
  _SeenDevice({required this.deviceId, required this.at});
}
