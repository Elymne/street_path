import 'package:poc_street_path/services/ble/ble_conf.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:poc_street_path/domain/usecases/sync/add_raw_data.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:poc_street_path/services/ble/assembly_buffer.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

class ScanService {
  ScanService();

  /// Dépendances (pas de riverpod dans cet env).
  final _pathProviderGatewayImpl = PathProviderGatewayImpl();
  late final _databaseGateway = ObjectBoxGateway(_pathProviderGatewayImpl);
  late final _rawDataRepository = RawDataRepositoryImpl(_databaseGateway);
  late final _addRawData = AddRawData(_rawDataRepository);

  // BLE
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  /// Scan.
  StreamSubscription<DiscoveredDevice>? _scanSub;

  /// Buffers de réassemblage.
  final Map<int, AssemblyBuffer> _buffers = {};

  void startListening(void Function(String) onMessage) {
    // Annule l'ancien scan si nécessaire
    _scanSub?.cancel();

    _scanSub = _ble.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
      final data = device.manufacturerData;
      if (data.length < 6) {
        return; // * Données à priori non conforme.
      }

      // Rappel : [VERSION 1B][PROTO_ID 1B][TYPE 1B][MSG_ID 2B][CHUNK_INDEX 1B][TOTAL_CHUNKS 1B][PAYLOAD JSON]
      final payloadVersion = data[0];
      final receivedProtoId = data[1];
      final type = data[2]; // todo : a utiliser plus tard surement.
      final msgId = (data[3] << 8) | data[4];
      final chunkIndex = data[5];
      final totalChunks = data[6];
      final payload = data.sublist(7);

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
