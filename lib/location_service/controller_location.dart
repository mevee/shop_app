import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shop_app/location_service/tracking_service.dart';

class TrackingController extends GetxController {
  final LocationTrackingService locationService = Get.find();

  Stream<Map<String, dynamic>> get updates {
    return FlutterBackgroundService().on('update').map((event) {
      return event as Map<String, dynamic>;
    });
  }

  void startTracking() {
    locationService.startTracking();
  }

  void stopTracking() {
    locationService.stopTracking();
  }
}
