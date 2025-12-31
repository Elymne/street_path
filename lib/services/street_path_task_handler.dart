import 'package:poc_street_path/domain/usecases/sync/get_shareable_posts.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/connectToDatabase.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/disconnectToDatabase.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/comment_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/content_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'dart:async';

import 'package:poc_street_path/services/ble/beacon_broadcast.dart';
import 'package:poc_street_path/services/ble/beacon_scan.dart';
import 'package:uuid/uuid.dart';

class StreetPathTaskHandler extends TaskHandler {
  /// * Pas d'injection via Riverpod possible ici.
  final _pathProviderGatewayImpl = PathProviderGatewayImpl();
  late final _objectBoxGateway = ObjectBoxGateway(_pathProviderGatewayImpl);

  late final _contentRepository = ContentRepositoryImpl(_objectBoxGateway);
  late final _commentRepository = CommentRepositoryImpl(_objectBoxGateway);
  late final _reactionRepository = ReactionRepositoryImpl(_objectBoxGateway);

  late final _connectToDatabase = ConnectToDatabase(_objectBoxGateway);
  late final _disconnectToDatabase = DisconnectToDatabase(_objectBoxGateway);
  late final _getShareableContents = GetShareableContents(_contentRepository, _commentRepository, _reactionRepository);

  final _beaconBroadcast = BeaconBroadcast();
  final _beaconScan = BeaconScan();

  /// L'ID de l'appareil est regénéré à chaque démarrage du service.
  final _streetpathId = Uuid().v4();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    SpLog().i('Streetpath Service: Checking permissions…');

    SpLog().i('Streetpath Service: Connection to database…');
    await _connectToDatabase.execute(ConnectToDatabaseParams());

    SpLog().i('Streetpath Service: Find data to share….');
    final result = await _getShareableContents.execute(GetShareableContentsParams());
    if (result is Failure) {
      SpLog().w('Streetpath Service: Error catched while using GetShareableContents.');
      return;
    }

    SpLog().i('Streetpath Service: Broadcasting beacon');
    _beaconBroadcast.start(_streetpathId);

    // SpLog().i('Streetpath Service: Scanning nearby beacons');
    // await _beaconScan.start((streetpathId) {
    //   /// todo : Detected, now let's start transfert
    //   SpLog().w('Streetpath Service: BEACON DETECTED $streetpathId');
    //   FlutterForegroundTask.sendDataToMain(streetpathId);
    // });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _disconnectToDatabase.execute(DisconnectToDatabaseParams());
    await _beaconBroadcast.stop();
    await _beaconScan.stop();
    SpLog().i('StreetPath Service: Stoped');
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
