import 'dart:io';
import 'package:poc_street_path/core/globals.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/street_path/street_path_task_handler.dart';

/// Implémentation de l'interface StreetPathGateway.
/// Cette implémentation utilise la lib flutter_foreground_task pour créer le service qui tourne en background.
/// Documentation forescan_foreground_task : https://pub.dev/packages/flutter_foreground_task/example
class StreetPathGatewayImpl implements StreetPathGateway {
  @override
  Future init() async {
    FlutterForegroundTask.initCommunicationPort();

    // * Check des permissions.
    final NotificationPermission notifPerms = await FlutterForegroundTask.checkNotificationPermission();
    if (notifPerms != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid && !await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // * Initialisation du background service en background.
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: streetPathServiceName,
        channelName: streetPathChannelDesc,
        channelDescription: streetPathChannelDesc,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
      // ! Je ne compte pas gérer le cas IOS pour l'instant (protocole BLE compliqué via les restriction apple).
      iosNotificationOptions: const IOSNotificationOptions(showNotification: false, playSound: false),
    );
  }

  @override
  Future start(String notificationTitle, String notificationText) async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.restartService();
      return;
    }

    FlutterForegroundTask.startService(
      serviceId: streetPathServiceId,
      notificationTitle: notificationTitle,
      notificationText: notificationText,
      notificationIcon: null,
      notificationButtons: [],
      notificationInitialRoute: null,
      serviceTypes: [ForegroundServiceTypes.connectedDevice, ForegroundServiceTypes.dataSync, ForegroundServiceTypes.remoteMessaging],
      callback: streetPathTaskHandlerCallback,
    );
  }

  @override
  Future stop() async {
    FlutterForegroundTask.stopService();
  }

  @override
  Future onReceivedData(Object data) {
    // TODO: implement onReceivedData
    throw UnimplementedError();
  }
}
