import 'package:poc_street_path/services/ble/ble_conf.dart';
import 'package:poc_street_path/services/ble/assembly_buffer.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

class ScanService {
  ScanService();

  // BLE
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  /// Scan.
  StreamSubscription<DiscoveredDevice>? _scanSub;

  /// Buffers de réassemblage.
  final Map<int, AssemblyBuffer> _buffers = {};

  void startListening(void Function(String) onMessage) {
    // Annule l'ancien scan si nécessaire
    _scanSub?.cancel();

    _scanSub = _ble
        .scanForDevices(
          withServices: [
            ///
            Uuid.parse(bleServiceId),
          ],
          scanMode: ScanMode.lowLatency,
        )
        .listen((device) {
          final data = device.manufacturerData;
          if (data.length < 6) {
            return; // * Données à priori non conforme.
          }

          final payloadVersion = data[0]; // VERSION 1B
          final receivedProtoId = data[1]; // PROTO_ID 1B
          final type = data[2]; // TYPE 1B
          final msgId = (data[3] << 8) | data[4]; // MSG_ID 2B
          final chunkIndex = data[5]; // CHUNK_INDEX 1B
          final totalChunks = data[6]; // TOTAL_CHUNKS 1B
          final payload = data.sublist(7); // PAYLOAD JSON

          // Vérification.
          if (payloadVersion != blePayloadVersion) return; // * Vérif payload.
          if (receivedProtoId != bleProtocolId) return; // * Vérif Protocole.

          // Récupération / création du buffer pour ce message
          _cleanupBuffers(); // * On clean les vieux fragments au cas où.
          final buffer = _buffers.putIfAbsent(msgId, () => AssemblyBuffer(totalChunks));
          buffer.add(chunkIndex, payload);

          // Si message complet, décoder et appeler le callback
          if (buffer.isComplete) {
            try {
              final jsonMap = jsonDecode(utf8.decode(buffer.assemble())) as String;
              onMessage(jsonMap);
            } catch (e) {
              if (kDebugMode) {
                print('Erreur décodage JSON : $e');
              }
            }
            _buffers.remove(msgId);
          }
        });
  }

  void stopListening() {
    _scanSub?.cancel();
    _scanSub = null;
  }

  void _cleanupBuffers() {
    final expired = _buffers.entries.where((e) => e.value.isExpired).map((e) => e.key).toList();
    for (final key in expired) {
      _buffers.remove(key);
    }
  }
}
