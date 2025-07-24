// // Start foreground service
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:location/location.dart';

// void startLocationService() async {
//   final location = Location();
  
//   await location.enableBackgroundMode(enable: true);
  
//   location.changeSettings(
//     accuracy: LocationAccuracy.high,
//     interval: 10000, // 10 seconds
//     distanceFilter: 10, // meters
//   );

//   location.onLocationChanged.listen((LocationData currentLocation) {
//     _handleLocationUpdate(currentLocation);
//     _showNotification(currentLocation);
//   });
// }

// void _showNotification(LocationData location) {
//   FlutterLocalNotificationsPlugin().show(
//     0,
//     "Location Update",
//     "Lat: ${location.latitude}, Lng: ${location.longitude}",
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         "location_channel",
//         "Location Updates",
//         importance: Importance.max,
//         priority: Priority.high,
//         ongoing: true,
//       ),
//     ),
//   );
// }