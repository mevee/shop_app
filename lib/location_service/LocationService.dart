import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

class LocationSerivice extends GetxService {
  // Start Background Task
  // Call this when user enables tracking
  void startBackgroundLocation() {
    Workmanager().registerPeriodicTask(
      "locationTask",
      "fetchLocation",
      frequency: Duration(minutes: 1),
    );
  }

  // Call this when user disables tracking
  void stopBackgroundLocation() {
    Workmanager().cancelByTag("locationTask");
  }
}
