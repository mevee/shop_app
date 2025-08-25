import 'package:connectivity_plus/connectivity_plus.dart';

class NetUtil {
  static Future<bool> isNetworkAvailable() async {
    // Handle connectivity check
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
