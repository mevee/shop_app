import 'dart:async';

import 'package:shop_app/location_service/workmanger_util.dart';
import 'package:workmanager/workmanager.dart'
    show Constraints, NetworkType, Workmanager;

Future<void> initializeBackgroundService() async {
  //-------------new with work manager
  // Initialize Workmanager
  Workmanager().initialize(
    callbackDispatcher, // Top-level function (see below)
    isInDebugMode: true,
  );
  // Start periodic task (every 1 minutes)
  Workmanager().registerPeriodicTask(
    "locationTask",
    "fetchLocation",
    frequency: Duration(minutes: 1),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
