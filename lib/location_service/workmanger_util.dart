// Top-level function (MUST BE OUTSIDE ANY CLASS)
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point') // Required for Flutter 3.3+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Workmanager().executeTask:$task");
    if (task == "fetchLocation") {
      await _fetchAndSaveLocation();
      return true;
    }
    return false;
  });
}

Future<void> checkAndRequestNotificationPermissions() async {
  // For Android 13+ (API 33+)
  if (Platform.isAndroid) {
    final androidVersion = await DeviceInfoPlugin().androidInfo;
    if (androidVersion.version.sdkInt >= 33) {
      // Check notification permission status
      var status = await Permission.notification.status;

      if (!status.isGranted) {
        // Request permission if not granted
        status = await Permission.notification.request();

        if (status.isDenied || status.isPermanentlyDenied) {
          // Handle denied permission (show rationale or open settings)
          // await openAppSettings();
          // return;
        }
      }
    }
  }
}

Future<void> _fetchAndSaveLocation() async {
  // Check permissions
  bool hasPermission = await _checkLocationPermission();
  if (!hasPermission) return;
  await checkAndRequestNotificationPermissions();
  // Get current location
  Position? position = await Geolocator.getCurrentPosition(
    // desiredAccuracy: LocationAccuracy.bestForNavigation,
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      timeLimit: Duration(seconds: 4),
    ),
  );

  // // Save to SharedPreferences (or send to server)
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.setString('last_location', '${position.latitude},${position.longitude}');

  print("LOC321:${position.latitude},${position.longitude}");
  
  // Show notification (optional)
  FlutterLocalNotificationsPlugin().show(
    0,
    "Location Updated",
    "Lat: ${position.latitude}, Lng: ${position.longitude}",
    NotificationDetails(
      android: AndroidNotificationDetails(
        "location_channel",
        "Location Updates",
        importance: Importance.max,
        priority: Priority.high,
        icon: null, // Explicitly set the icon
        // For Android 8.0+, also set the large icon (optional)
        largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      ),
    ),
  );
}

Future<bool> _checkLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}
