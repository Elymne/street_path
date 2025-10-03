import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

/// Implémentation de l'interface StreetPathGateway.
/// Cette implémentation utilise la lib flutter_reactive_ble pour gérer les transferts BLE.
/// Cette implémentation utilise la lib flutter_foreground_task pour créer le service qui tourne en background.
class StreetPathGatewayImpl implements StreetPathGateway {
  @override
  Future start() async {
    FlutterForegroundTask.initCommunicationPort();
  }

  @override
  Future stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }

  @override
  Future cancel() {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  Future<int> getStatus() {
    // TODO: implement getStatus
    throw UnimplementedError();
  }
}
