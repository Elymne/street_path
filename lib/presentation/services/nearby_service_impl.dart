import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/usecases/data/add_raw_data.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_impl.repository.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';

/// ! Riverpod est inutilisable dans ce contexte : vous ne pouvez pas utiliser de Provider !
class NearbyServiceImpl {
  late final NearbyService _nearbySevice = NearbyService();

  late final _databaseGateway = ObjectBoxGateway();
  late final _rawDataRepository = RawDataRepositoryImpl(_databaseGateway);
  late final _addRawData = AddRawData(_rawDataRepository);

  late final StreamSubscription _subscription;
  late final StreamSubscription _receivedDataSubscription;
  final List<_SeenDevice> _seenDevices = [];

  late final Timer dutyCycler; // *  http://iot-strasbourg.strataggem.com/ref/duty-cycle.html

  String _shareableData = jsonEncode([]); // * Data à share.

  NearbyServiceImpl();

  void setShareableData(List<Content> contents, List<Comment> comments, List<Reaction> reactions) {
    _shareableData = jsonEncode([...contents, ...comments, ...reactions]);
  }

  Future init() async {
    SpLog().i('StreetPath scan starting…');
    await _nearbySevice.init(
      serviceType: 'com.cyneila.streetpath',
      strategy: Strategy.P2P_CLUSTER,
      deviceName: '$streetPathSignatureName:${Uuid().v4()}',
      callback: (dynamic _) async {
        SpLog().i('StreetPath scan has started.');
      },
    );
  }

  /// Fait pas mal de trucs :
  /// - Commence l'écoutes les changements lorsque des appareils avec le BLE/WIFI d'activité sont détecté par l'appareil.
  /// - Tentes des connections sur les appareils reconnu.
  /// - Tentes de transférer de la data sur les appareils reconnu et connecté.
  Future run() async {
    _subscription = _nearbySevice.stateChangedSubscription(
      callback: (devicesList) {
        final seensId = _seenDevices.map((elem) => elem.deviceId);
        for (final device in devicesList) {
          SpLog().i("Device WIFI/BLE detected : deviceId: ${device.deviceId} | deviceName: ${device.deviceName} | state: ${device.state}");

          if (seensId.contains(device.deviceId)) {
            continue; // * Déjà vu, on skip.
          }

          if (device.state == SessionState.connecting) {
            continue; // * En cours de connexion, on skip en attendant le prochain event.
          }

          final signature = device.deviceName.split(":")[0];
          if (signature != streetPathSignatureName) {
            _seenDevices.add(_SeenDevice(deviceId: device.deviceId, at: DateTime.now().millisecondsSinceEpoch));
            continue; // * Mauvaise signature. On ajoute aux déjà vu et on skip.
          }

          if (device.state == SessionState.notConnected) {
            _nearbySevice.invitePeer(deviceID: device.deviceId, deviceName: device.deviceName);
            continue; // * On s'est jamais connecté. On tente et on skip.
          }

          if (device.state == SessionState.connected) {
            _nearbySevice.sendMessage(device.deviceId, _shareableData);
            _seenDevices.add(_SeenDevice(deviceId: device.deviceId, at: DateTime.now().millisecondsSinceEpoch));
            continue; // * On est connecté. On envoie la data qu'on peut en fonction du mode d'envoie puis on ajoute aux déjà vu et on skip.
          }
        }
      },
    );

    // * Reception de data.
    _receivedDataSubscription = _nearbySevice.dataReceivedSubscription(
      callback: (data) {
        SpLog().i("Data fetched from device : ${jsonEncode(data)}");
        _addRawData.execute(AddRawDataParams(data: jsonEncode(data)));
        SpLog().i("Data injected into device");
      },
    );

    // * Duty Cycler.
    dutyCycler = Timer.periodic(Duration(seconds: 30), (timer) async {
      _nearbySevice.startBrowsingForPeers();
      _nearbySevice.startAdvertisingPeer();
      Future.delayed(Duration(seconds: 5), () {
        _nearbySevice.stopBrowsingForPeers();
        _nearbySevice.stopAdvertisingPeer();
      });
    });
  }

  Future stop() async {
    await _nearbySevice.stopBrowsingForPeers();
    await _nearbySevice.stopAdvertisingPeer();
    await Future.wait([_subscription.cancel(), _receivedDataSubscription.cancel()]);
    dutyCycler.cancel();
  }
}

class _SeenDevice {
  final String deviceId;
  final int at;
  _SeenDevice({required this.deviceId, required this.at});
}
