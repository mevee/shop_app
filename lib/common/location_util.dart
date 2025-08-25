import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/models/employee_response.dart';

class LocationUtil {
  static Future<void> getLocation(
    Function(LocationLatLon location) onLocatiionFound,
  ) async {
    // Check permissions
    final status = await Permission.location.request();
    if (!status.isGranted) {
      AppToast.showToast(message: 'Location permission denied');
      return;
    } else {
      // Get current position
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 0,
          ),
        );
        onLocatiionFound(
          LocationLatLon(lat: position.latitude, long: position.longitude),
        );
      } catch (e) {
        //show bottom sheet error for need of location permission
        // AppToast.showToast(message: 'Failed to get location: ${e.toString()}');
      } finally {}
    }
  }
}
