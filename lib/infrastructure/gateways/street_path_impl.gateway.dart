import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poc_street_path/services/street_path_task_handler.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/globals.dart';
import 'dart:io';

@pragma('vm:entry-point')
void streetPathTaskHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(StreetPathTaskHandler());
}

final streetPathGatewayProvider = Provider<StreetPathGateway>((ref) => StreetPathGatewayImpl());

class StreetPathGatewayImpl implements StreetPathGateway {
  @override
  Future<bool> canRun() async {
    // todo : La fonction a l'air stupide mais il ets possible que j'ai plusieurs vérification à chain.
    final isSupported = await FlutterBlePeripheral().isSupported;
    if (!isSupported) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> checkPermissions() async {
    final permissions = [Permission.bluetooth, Permission.bluetoothConnect, Permission.bluetoothAdvertise];
    final statuses = await permissions.request();
    if (statuses.values.any((s) => !s.isGranted)) {
      return false;
    }
    return true;
  }

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
        eventAction: ForegroundTaskEventAction.repeat(5_000),
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
      serviceTypes: [
        ForegroundServiceTypes.dataSync,
        ForegroundServiceTypes.remoteMessaging,
        ForegroundServiceTypes.connectedDevice,
      ],
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
