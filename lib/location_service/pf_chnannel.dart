import 'package:flutter/services.dart';

class BatteryOptimizationUtil {
  static const platform = MethodChannel('your_channel_name/battery');

  // Check if battery optimization is enabled for the app
  static Future<bool> isBatteryOptimizationEnabled() async {
    try {
      return await platform.invokeMethod('isBatteryOptimizationEnabled');
    } on PlatformException {
      return false; // Default to false if there's an error
    }
  }

  // Open battery optimization settings
  static Future<void> openBatteryOptimizationSettings() async {
    try {
      await platform.invokeMethod('openBatteryOptimizationSettings');
    } on PlatformException {
      // Handle error
    }
  }
}