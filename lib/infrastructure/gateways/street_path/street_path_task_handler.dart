import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/street_path/nearby_service_impl.dart';

// * Obligé d'utiliser une fonction statique pour le callback lors de démarrage du service.
/// ! Riverpod est inutilisable dans ce contexte : vous ne pouvez pas utiliser de Provider !
@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}

/// Classe utilisé par l'implémentation de l'interface StreetPathGateway : StreetPathGatewayImpl
/// Comporte une liste de callback de la classe TaskHandler pour créer un service qui tourne en background.
/// C'est elle qui va s'occuper de récupérer les appareils proches détectés.
/// Cette classe tourne sur un autre thread que la mainUI.
class StreetPathTaskHandler extends TaskHandler {
  late final ObjectBoxGateway _objectBoxGateway = ObjectBoxGateway();
  late final _nearbyServiceImpl = NearbyServiceImpl();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    SpLog.instance.i('Streetpath Service : Initialize…');
    await _objectBoxGateway.init();
    Future.wait([_nearbyServiceImpl.init(_objectBoxGateway.getConnector()!)]);
    SpLog.instance.i('Streetpath Service : Started.');
    await _nearbyServiceImpl.run();
    SpLog.instance.i('Streetpath Service : Running.');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await Future.wait([_objectBoxGateway.close(), _nearbyServiceImpl.stop()]);
    SpLog.instance.i('StreetPath Service : Stoped');
  }

  @override
  void onReceiveData(Object data) {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}
