import 'dart:convert';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/location_service/permission_helper.dart';
import 'package:shop_app/location_service/tracking_service.dart';

import '../data/network/api_endpoint.dart';
import '../data/session_pref_impl.dart';
import '../utils/constants.dart';

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';
// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

class FlutterBgService {
  FlutterBgService._internal();

  static final FlutterBgService _instance = FlutterBgService._internal();

  factory FlutterBgService() {
    return _instance;
  }

  void initializeService() async {
    final service = FlutterBackgroundService();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      playSound: false,
      enableVibration: false,
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: notificationChannelId,
        // this must match with notification channel you created above.
        initialNotificationTitle: 'Location Tracker Running',
        initialNotificationContent: 'Tracking your location',
        foregroundServiceNotificationId: notificationId,
      ),
    );
    // service.startService();
  }

  // Start service
  void startTracking() async {
    print("startTracking()");
    initializeService();
    await FlutterBackgroundService().startService();
  }

  // Stop service
  void stopTracking() async {
    FlutterBackgroundService().invoke('stop');
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
  }
  LocationSyncService syncService = LocationSyncService();
  await syncService.init();
  await syncService.loadLocationsFromPrefs();
    // 3. For Android 15, check if we have precise location access
  // await PermissionUtil.locationPermissionCheck();
  await PermissionUtil.checkLocationServiceEnabled();
  // Main tracking loop
  while (true) {
    // Check if the service is running in foreground mode
    //if location fetch is enabled
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Location Tracker",
        content: "Last update: ${DateTime.now()}",
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        ),
      );
      // syncService.startRecording(position);
      print('Backgournd Lat: ${position.latitude}, Lng: ${position.longitude}');
      // Save to SharedPreferences or send to server
      // if (kProfileMode | kReleaseMode) {
      await syncService.startRecording(position);
      await _syncLocationsWithServer(syncService);
    } catch (e) {
      print('Error fetching location: $e');
    }
    await Future.delayed(Duration(seconds: 10));
    // } else {
    // await Future.delayed(Duration(minutes: 2));
    // }
  }
}

Future<void> _syncLocationsWithServer(LocationSyncService sync) async {
  print("_syncLocationsWithServer()");
  try {
    // Get your token from shared preferences
    final working = sync.session.getIsWorking();
    final userName = sync.session.getUserData()?.login?.userName;
    final token = sync.session.getUserToken();
    // print("try ::userName$userName");
    if (userName == null || userName.isEmpty) {
      // lastError = 'User not authenticated';
      return;
    }
    print("try ::working$working");
    if (working == null || working == false) {
      return;
    }
    aLog("TO be synced::${sync.getLocationsToBeSent().length}");
    // Prepare data to send
    sendLogToServer(token, sync);
  } catch (e) {
    // lastError = 'Sync error: ${e.toString()}';
    print("sync ::WORKING$e");
  }
}

void sendLogToServer(String? token, LocationSyncService syncService) async {
  print("sendLogToServer()");

  final url = Uri.parse(
    '${AppConstants.baseUrl}${EndPoints.employeeRouteUpdatePOST}',
  );
  final request = syncService.getLocationsToBeSent();
  if (kDebugMode) {
    print('request: ${request.map((item) => item.toJson()).toList()}');
  }
  try {
    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token', // Add token here
          },
          body: json.encode(request.map((item) => item.toJson()).toList()),
        )
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      syncService.clerSyncedLocations(request);
      if (kDebugMode) {
        print('Success: ${response.body}');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    // print('Exception: $e');
  }
}
