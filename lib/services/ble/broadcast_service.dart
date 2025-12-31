import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:poc_street_path/services/ble/ble_conf.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

class BroadcastService {
  BroadcastService();

  // BLE
  final FlutterBlePeripheral _peripheral = FlutterBlePeripheral();

  /// Lance un envoi de messages fragmentés
  Future<void> broadcastMessages(String data) async {
    // Convertir la String JSON en bytes UTF-8
    final chunks = createMessageFragments(data);

    for (final chunk in chunks) {
      final advertiseData = AdvertiseData(
        manufacturerId: bleManufacturerId,
        manufacturerData: chunk,
        includeDeviceName: false,
      );

      // Envoyer le fragment
      await _peripheral.start(advertiseData: advertiseData);

      // Petit délai pour laisser le fragment être reçu
      await Future.delayed(const Duration(milliseconds: 50));

      // Stop le broadcast pour le fragment
      await _peripheral.stop();
    }
  }

  /// Crée des fragments BLE à partir d'un message JSON.
  /// Chaque fragment contient un en-tête :
  /// [VERSION 1B][PROTO_ID 1B][TYPE 1B][DATA_ID 2B][CHUNK_INDEX 1B][TOTAL_CHUNKS 1B][PAYLOAD JSON]
  List<Uint8List> createMessageFragments(String message, {int chunkSize = 18}) {
    // Encode le message JSON en bytes
    final fullPayload = utf8.encode(jsonEncode(message));

    // ID unique du message (2 octets)
    final dataId = Random().nextInt(65535);

    // Taille de l'en-tête fixe pour chaque chunk
    const headerSize = 7;

    // Payload maximum par chunk
    final maxChunkPayload = chunkSize - headerSize;

    // Nombre total de chunks
    final totalChunks = (fullPayload.length / maxChunkPayload).ceil();

    final chunks = <Uint8List>[];

    for (int i = 0; i < totalChunks; i++) {
      // Extraction du fragment de payload
      final chunkData = fullPayload.skip(i * maxChunkPayload).take(maxChunkPayload).toList();

      // Construction du header + payload
      final chunkWithHeader = [
        blePayloadVersion, // VERSION
        bleProtocolId, // PROTO_ID
        bleTypeIdContents, // TYPE
        (dataId >> 8) & 0xFF, // DATA_ID high
        dataId & 0xFF, // DATA_ID low
        i, // CHUNK_INDEX
        totalChunks, // TOTAL_CHUNKS
        ...chunkData, // PAYLOAD JSON
      ];

      chunks.add(Uint8List.fromList(chunkWithHeader));
    }

    return chunks;
  }
}
