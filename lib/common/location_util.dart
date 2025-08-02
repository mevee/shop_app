import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/models/employee_response.dart';

class LocationUtil {
  static Future<void> getLocation(
    Function(LocationLatLon location) onLocatiionFound,
  ) async {
    try {
      // Check permissions
      final status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('Location permission denied');
      }
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      onLocatiionFound(
        LocationLatLon(lat: position.latitude, long: position.longitude),
      );
    } catch (e) {
      //show bottom sheet error for need of location permission
      AppToast.showToast(message: 'Failed to get location: ${e.toString()}');
    } finally {}
  }
}
