import 'package:permission_handler/permission_handler.dart';
import 'package:poc_street_path/domain/usecases/sync/get_shareable_posts.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/connectToDatabase.usecase.dart';
import 'package:poc_street_path/domain/usecases/database/disconnectToDatabase.usecase.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/comment_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/content_repository_impl.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/reaction_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/path_provider_impl.gateway.dart';
import 'package:poc_street_path/services/ble/broadcast_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/services/ble/scan_service.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'dart:async';

class StreetPathTaskHandler extends TaskHandler {
  // * Pas d'injection via Riverpod possible ici.
  late final _pathProviderGatewayImpl = PathProviderGatewayImpl();
  late final _objectBoxGateway = ObjectBoxGateway(_pathProviderGatewayImpl);
  late final _contentRepository = ContentRepositoryImpl(_objectBoxGateway);
  late final _commentRepository = CommentRepositoryImpl(_objectBoxGateway);
  late final _reactionRepository = ReactionRepositoryImpl(_objectBoxGateway);
  late final _getShareableContents = GetShareableContents(_contentRepository, _commentRepository, _reactionRepository);
  late final _connectToDatabase = ConnectToDatabase(_objectBoxGateway);
  late final _disconnectToDatabase = DisconnectToDatabase(_objectBoxGateway);

  /// Mes deux services BLE.
  late final _broadcastService = BroadcastService();
  late final _scanService = ScanService();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    /// Je devrais faire ça à partir d'un usecase surement mais pour la simplicité, j'fais ça là.
    /// A mettre plus tard dans un usecase pour mieux découper et éviter que cette classe n'est trop de dépendances.
    /// TODO: En vrai, ça pue du cul de faire ça ici.
    await [
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    SpLog().i('Streetpath Service: Connection to database.');
    await _connectToDatabase.execute(ConnectToDatabaseParams());

    SpLog().i('Streetpath Service: Broadcasting…');
    // _broadcastService.broadcastMessages();

    SpLog().i('Streetpath Service: Scanning….');
    // _scanService.startListening((message) {});
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _disconnectToDatabase.execute(DisconnectToDatabaseParams());
    _scanService.stopListening();
    SpLog().i('StreetPath Service: Stoped');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    final result = await _getShareableContents.execute(GetShareableContentsParams());
    if (result is Failure) {
      SpLog().w('Streetpath Service: Error catched while using GetShareableContents.');
      return;
    }
    _broadcastService.broadcastMessages('[]');
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
