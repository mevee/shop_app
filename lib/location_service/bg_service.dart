import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

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
        notificationChannelId:
            notificationChannelId, // this must match with notification channel you created above.
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
  final location = Geolocator(); // or Location()
  // Main tracking loop
  while (true) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Location Tracker",
        content: "Last update: ${DateTime.now()}",
      );
    }
    // Get location
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
      // timeLimit: Duration(seconds: 5)
    );

    print('Lat: ${position.latitude}, Lng: ${position.longitude}');
    // Save to SharedPreferences or send to server
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('last_location',
    //   'Lat: ${position.latitude}, Lng: ${position.longitude}'
    // );
    // Delay between updates (minimum 1 second)
    await Future.delayed(Duration(seconds: 10));
  }
}
