import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> _checkLocationService() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request location permissions
  Future<bool> _requestPermission() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  // Get current position with accuracy settings
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      if (!await _checkLocationService()) {
        // You might want to prompt user to enable location services
        return null;
      }

      // Check and request permissions
      if (!await _requestPermission()) {
        return null;
      }

      // Get current position with desired accuracy
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 0),
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  // Get continuous location updates (for tracking)
  Stream<Position> getLocationUpdates() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation,distanceFilter: 0),
      // desiredAccuracy: LocationAccuracy.bestForNavigation,
      // distanceFilter: 0, // Minimum distance (in meters) to trigger update
    );
  }
}