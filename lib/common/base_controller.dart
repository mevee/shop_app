import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';

class BaseController extends GetxController {
  final SessionPref userManager = SPrefSessiomImpl();
  Position? currentPosition;

  Future<void> refreshLocation() async {
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
      currentPosition = position;
    } catch (e) {
      //show bottom sheet error for need of location permission
      AppToast.showToast(message: 'Failed to get location: ${e.toString()}');
    } finally {}
  }
}
