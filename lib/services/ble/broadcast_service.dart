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
    final payloadBytes = _encodeMessage(data);

    // Créer les fragments (Uint8List) pour BLE
    final chunks = _createFragments(Uint8List.fromList(payloadBytes));

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

  /// Informations importantes : format du message.
  ///  *[VERSION 1B][PROTO_ID 1B][TYPE 1B][DATA_ID 2B][CHUNK_INDEX 1B][TOTAL_CHUNKS 1B][PAYLOAD JSON]
  List<int> _encodeMessage(String message) {
    final jsonBytes = utf8.encode(jsonEncode(message));
    final dataId = Random().nextInt(65535);
    return [
      /// * [VERSION 1B]
      blePayloadVersion,

      /// * [PROTO_ID 1B]
      bleProtocolId,

      /// * [TYPE 1B]
      bleTypeContents,

      /// * [DATA_ID 2B]
      (dataId >> 8) & 0xFF,
      dataId & 0xFF,

      /// ! Y a rien car ce truc est mal fait
      /// TODO : Refaire cette fonction, voir la partie en entière. Ne devrait-être qu'une seule fonction imo : CreateFragment et c'est tout.

      /// * [PAYLOAD JSON]
      ...jsonBytes,
    ];
  }

  /// Permet de découper le contenu en chunks sinon c'est trop gros.
  List<Uint8List> _createFragments(Uint8List fullPayload, {int chunkSize = 18}) {
    //  * On doit retirer la taille de l'en-tête que l'on va injecter pour chaque chunk
    //  * [VERSION 1B] [PROTO_ID 1B] [TYPE 1B] [MSG_ID 2B] [CHUNK_INDEX 1B] [TOTAL_CHUNKS 1B] = 7
    final headerSize = 7;
    final dataId = Random().nextInt(65535);

    final maxChunkPayload = chunkSize - headerSize;
    final totalChunks = (fullPayload.length / maxChunkPayload).ceil();
    final chunks = <Uint8List>[];

    for (int i = 0; i < totalChunks; i++) {
      final chunkData = fullPayload.skip(i * maxChunkPayload).take(maxChunkPayload).toList();

      // Préfixe : version, protoId, type, msgId (4 ou 5 octets selon ton format), + chunkIndex + totalChunks
      final chunkWithHeader = [
        /// * [VERSION 1B]
        blePayloadVersion,

        /// * [PROTO_ID 1B]
        bleProtocolId,

        /// * [TYPE 1B]
        bleTypeContents,

        /// * [DATA_ID 2B]
        (dataId >> 8) & 0xFF,
        dataId & 0xFF,

        /// * [CHUNK_INDEX 1B]
        i,

        /// * [TOTAL_CHUNKS 1B]
        totalChunks,

        /// * [PAYLOAD JSON]
        ...chunkData,
      ];

      chunks.add(Uint8List.fromList(chunkWithHeader));
    }

    return chunks;
  }
}
