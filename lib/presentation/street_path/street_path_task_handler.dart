import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/domain/usecases/database/connectToDatabase.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/disconnectToDatabase.usecase.dart';
import 'package:poc_street_path/infrastructure/gateways/database/object_box_impl.gateway.dart';
import 'package:poc_street_path/presentation/street_path/nearby_service_impl.dart';

class StreetPathTaskHandler extends TaskHandler {
  late final ObjectBoxGateway _objectBoxGateway = ObjectBoxGateway();
  late final ConnectToDatabase _connectToDatabase = ConnectToDatabase(_objectBoxGateway);
  late final DisconnectToDatabase _disconnectToDatabase = DisconnectToDatabase(_objectBoxGateway);

  late final _nearbyServiceImpl = NearbyServiceImpl();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    SpLog().i('Streetpath Service : Initialize…');
    await _connectToDatabase.execute(ConnectToDatabaseParams());
    await _nearbyServiceImpl.init();
    SpLog().i('Streetpath Service : Started.');
    await _nearbyServiceImpl.run();
    SpLog().i('Streetpath Service : Running.');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _disconnectToDatabase.execute(DisconnectToDatabaseParams());
    await _nearbyServiceImpl.stop();
    SpLog().i('StreetPath Service : Stoped');
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
