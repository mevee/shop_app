import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/location_service/permission_helper.dart';
import 'package:shop_app/location_service/tracking_service.dart';

import '../data/network/api_endpoint.dart';
import '../utils/constants.dart';

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';
// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

class FlutterBgService {
  static void initializeService() async {
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
  static void startTracking(SessionPref userManager) async {
    print("startTracking()");
    updateUserData(userManager);
    initializeService();
    await FlutterBackgroundService().startService();
  }

  // Start service
  static void updateUserData(SessionPref userManager) async {
    print("updateUserData()");
    FlutterBackgroundService().invoke('setData', {
      'userId': userManager.getUserId(),
      'token': userManager.getUserToken(),
      'working': userManager.getIsWorking() ?? false,
    });
  }

  // Stop service
  static void disableLoctionService() async {
    FlutterBackgroundService().invoke('setData', {
      'userId': null,
      'token': null,
      'working': false,
    });
  }

  // Stop service
  static void stopTracking() async {
    // FlutterBackgroundService().invoke('setData', {});
    FlutterBackgroundService().invoke('stop');
    FlutterBackgroundService().invoke('stopBackgroundService');
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  aLog("onStart() service");
  //  aLog("W:${whileUserIsWorking}U:${pref.getUserData()?.login?.userName}");
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic>? initialData;
  // Listen for data from main app
  LocationSyncService syncService = LocationSyncService();
  await syncService.init();
  await syncService.loadLocationsFromPrefs();

  service.on('setData').listen((event) async {
    initialData = event;
    aLog("setData()->listen() $initialData");
    await syncService.init();
    await syncService.loadLocationsFromPrefs();
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
  }
  final permision = await PermissionUtil.checkLocationServiceEnabled();
  // Main tracking loop
  while (permision) {
    aLog("while(IsWorking${initialData?['working']})");
    // Check if the service is running in foreground mode
    String? userId = initialData?['userId'] ?? "";
    String? token = initialData?['token'] ?? "";
    //if location fetch is enabled
    String message = !(kDebugMode | kProfileMode)
        ? (initialData?['working'] == true)
              ? "Updated ${DateTime.now()}"
              : "Sync paused"
        : "W:${initialData?['working']}U:${initialData?['userId']}";

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Location Tracker",
        content: message,
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
      if (initialData?['working'] == true) {
        await syncService.startRecording(position, userId);
        await _syncLocationsWithServer(syncService, userId, token);
      } else {
        aLog("User is not working.");
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
    await Future.delayed(Duration(seconds: 10));
  }
}

Future<void> _syncLocationsWithServer(
  LocationSyncService sync,
  String? userName,
  String? token,
) async {
  print("_syncLocationsWithServer()");
  try {
    // Get your token from shared preferences
    aLog("TO be synced::${sync.getLocationsToBeSent().length}");
    // Prepare data to send
    sendLogToServer(token, sync);
  } catch (e) {
    print("sync ::Catch$e");
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
