import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:poc_street_path/services/ble/beacon_conf.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

class BeaconBroadcast {
  BeaconBroadcast();

  final FlutterBlePeripheral _peripheral = FlutterBlePeripheral();

  /// Démarre le système de broadcast qui va envoyer l'identifiant StreetPath de l'utilisateur pour être détecté par d'autres utilisateurs.
  /// Si ce système n'est pas activé, l'appareil ne peut pas être détecté et aucun transfert ne peut-être effectués.
  Future<void> start(String streetpathId) async {
    final advertiseData = AdvertiseData(
      serviceUuid: bleServiceId,
      manufacturerId: bleManufacturerId,
      manufacturerData: Uint8List.fromList([
        blePayloadVersion, // VERSION 1B.
        bleProtocolId, // PROTO_ID 1B.
        ...utf8.encode(streetpathId), // STREET PATH ID UUID.
      ]),
    );

    final advertiseSettings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeLowPower,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerLow,
      timeout: 3000,
    );

    await _peripheral.start(advertiseData: advertiseData, advertiseSettings: advertiseSettings);
  }

  Future<void> stop() async {
    await _peripheral.stop();
  }
}
