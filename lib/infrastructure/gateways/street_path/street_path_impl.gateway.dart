import 'dart:io';
import 'package:poc_street_path/core/globals.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:poc_street_path/presentation/services/street_path_task_handler.dart';

class StreetPathGatewayImpl implements StreetPathGateway {
  @override
  Future start(String notificationTitle, String notificationText) async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.restartService();
      return;
    }
    FlutterForegroundTask.initCommunicationPort();
    final NotificationPermission notifPerms = await FlutterForegroundTask.checkNotificationPermission();
    if (notifPerms != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    if (Platform.isAndroid && !await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: streetPathServiceName,
        channelName: streetPathChannelDesc,
        channelDescription: streetPathChannelDesc,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(600_000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(showNotification: false, playSound: false),
    );
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
  Future<StreetPathStatus> getStatus() async {
    if (await FlutterForegroundTask.isRunningService) return StreetPathStatus.active;
    return StreetPathStatus.inactive;
  }
}

@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}
