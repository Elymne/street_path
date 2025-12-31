import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:poc_street_path/services/ble/beacon_conf.dart';
import 'dart:async';

class BeaconScan {
  BeaconScan();

  final FlutterReactiveBle _reactive = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSub;

  Future<void> start(void Function(String) onBeaconDetected) async {
    // Annule l'ancien scan si nécessaire
    _scanSub?.cancel();
    final serviceId = Uuid.parse(bleServiceId);
    _scanSub = _reactive.scanForDevices(withServices: [serviceId], scanMode: ScanMode.lowLatency).listen((device) {
      final data = device.manufacturerData;
      if (data.length < 4) {
        return; // * Données à priori non conforme.
      }

      final payloadVersion = data[0]; // VERSION 1B
      final receivedProtoId = data[1]; // PROTO_ID 1B
      final payload = data.sublist(2); // PAYLOAD StreetPath ID

      // Vérification.
      if (payloadVersion != blePayloadVersion) return; // * Vérif payload.
      if (receivedProtoId != bleProtocolId) return; // * Vérif Protocole.

      // Décodage du streetpath ID externe et callback
      onBeaconDetected(utf8.decode(payload));
    });
  }

  Future<void> stop() async {
    _scanSub?.cancel();
    _scanSub = null;
  }
}
