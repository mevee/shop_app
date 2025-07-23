import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/location_service/tracking_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_tracker',
      initialNotificationTitle: 'Hamster Location Tracker Running',
      initialNotificationContent: 'Tracking your location in background',
      foregroundServiceNotificationId: 888,
      // Add this for Android 12+
      foregroundServiceTypes: [
        AndroidForegroundType.location,
        AndroidForegroundType.dataSync,
      ],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        service.setForegroundNotificationInfo(
          title: "Location Tracker",
          content: "Tracking your location in background",
        );
      } else {
        service.setForegroundNotificationInfo(
          title: "Location Tracker",
          content: "Tracking your location in background",
        );
      }
    }

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Initialize GetX
  Get.put(SharePrefSessiomImpl());
  final locationService = Get.put(LocationTrackingService());

  // Start tracking
  await locationService.startTracking();

  // Keep the service alive
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Location Tracker',
        content: 'Last sync: ${locationService.lastSyncStatus.value}',
      );
    }

    // Send updates to UI (if app is in foreground)
    service.invoke('update', {
      'status': locationService.lastSyncStatus.value,
      'error': locationService.lastError.value,
      'count': locationService.syncCount.value,
      'isTracking': locationService.isTracking.value,
    });
  });
}
