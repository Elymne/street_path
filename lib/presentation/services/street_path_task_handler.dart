import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/data/get_shareable_posts.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/connectToDatabase.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/disconnectToDatabase.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/raw_data_impl.repository.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:poc_street_path/presentation/services/nearby_service_impl.dart';

class StreetPathTaskHandler extends TaskHandler {
  late final _pathProviderGatewayImpl = PathProviderGatewayImpl();
  late final _objectBoxGateway = ObjectBoxGateway(_pathProviderGatewayImpl);
  late final _rawDataRepository = RawDataRepositoryImpl(_objectBoxGateway);
  late final _getShareableContents = GetShareableContents(_rawDataRepository);
  late final _connectToDatabase = ConnectToDatabase(_objectBoxGateway);
  late final _disconnectToDatabase = DisconnectToDatabase(_objectBoxGateway);

  late final _nearbyServiceImpl = NearbyServiceImpl();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    SpLog().i('Streetpath Service: Initialize…');
    await _connectToDatabase.execute(ConnectToDatabaseParams());
    await _nearbyServiceImpl.init();
    SpLog().i('Streetpath Service: Started.');
    await _nearbyServiceImpl.run();
    SpLog().i('Streetpath Service: Running.');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _disconnectToDatabase.execute(DisconnectToDatabaseParams());
    await _nearbyServiceImpl.stop();
    SpLog().i('StreetPath Service: Stoped');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    final result = await _getShareableContents.execute(GetShareableContentsParams(dataLimit: 10, dayLimit: 7));
    if (result is Failure) {
      SpLog().w('Streetpath Service: Error catched while using GetShareableContents.');
      return;
    }
    _nearbyServiceImpl.setShareableData((result as Success<String>).data);
  }

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}
