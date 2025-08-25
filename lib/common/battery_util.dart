// utils/battery_optimization_util.dart
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';

class BatteryOptimizationUtil {
  // Private constructor to prevent instantiation
  BatteryOptimizationUtil._();

  static final Battery _battery = Battery();
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Check if battery optimization is enabled for the app (Android only)
  static Future<bool> isBatteryOptimizationEnabled() async {
    try {
      if (!_isAndroid()) {
        return false; // iOS doesn't have battery optimization for apps
      }

      final androidInfo = await _deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 23) {
        // For Android M (API 23) and above
        const platform = MethodChannel('battery_optimization');
        final bool isIgnoringOptimizations = await platform.invokeMethod(
          'isIgnoringBatteryOptimizations',
        );
        // Return true if optimization is NOT ignored (meaning optimization is enabled)
        return !isIgnoringOptimizations;
      }
      return false; // For older Android versions
    } on PlatformException catch (e) {
      print('Error checking battery optimization: $e');
      return false;
    }
  }

  /// Request system to ignore battery optimization for this app
  static Future<void> requestIgnoreBatteryOptimization() async {
    if (!_isAndroid()) {
      return; // Only applicable for Android
    }

    try {
      final AndroidIntent intent = AndroidIntent(
        action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        data: 'package:${await _getPackageName()}',
      );
      await intent.launch();
    } catch (e) {
      print('Error requesting ignore battery optimization: $e');
      // Fallback to general battery optimization settings
      await openBatteryOptimizationSettings();
    }
  }

  /// Open battery optimization settings
  static Future<void> openBatteryOptimizationSettings() async {
    if (!_isAndroid()) {
      return; // Only applicable for Android
    }

    try {
      final AndroidIntent intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );
      await intent.launch();
    } catch (e) {
      print('Error opening battery optimization settings: $e');
      await _openAppSettings();
    }
  }

  /// Check if device is in power saving mode
  static Future<bool> isPowerSavingMode() async {
    try {
      final batteryState = await _battery.batteryState;
      final batteryLevel = await _battery.batteryLevel;

      // Power saving mode is typically active when battery is low and discharging
      return batteryState == BatteryState.discharging && batteryLevel < 20;
    } catch (e) {
      print('Error checking power saving mode: $e');
      return false;
    }
  }

  /// Get current battery level
  static Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      print('Error getting battery level: $e');
      return 100;
    }
  }

  /// Check if we should warn about battery optimization or power saving
  static Future<bool> shouldShowBatteryWarning() async {
    final bool isOptimized = await isBatteryOptimizationEnabled();
    final bool isPowerSaving = await isPowerSavingMode();

    return isOptimized || isPowerSaving;
  }

  /// Get battery status message
  static Future<String> getBatteryStatusMessage() async {
    final bool isOptimized = await isBatteryOptimizationEnabled();
    final bool isPowerSaving = await isPowerSavingMode();
    final int batteryLevel = await getBatteryLevel();

    if (isPowerSaving) {
      return 'Low battery mode active ($batteryLevel%). App performance may be affected.';
    }
    if (isOptimized) {
      return 'Battery optimization is enabled. This may affect app functionality.';
    }
    return 'Battery status: Normal ($batteryLevel%)';
  }

  // Private helper methods
  static bool _isAndroid() {
    return Platform.isAndroid;
  }

  static Future<String> _getPackageName() async {
    try {
      const platform = MethodChannel('battery_optimization');
      return await platform.invokeMethod('getPackageName');
    } catch (e) {
      // Fallback to hardcoded package name (replace with your actual package name)
      return 'com.yourpackage.name';
    }
  }

  static Future<void> _openAppSettings() async {
    try {
      if (_isAndroid()) {
        final AndroidIntent intent = AndroidIntent(
          action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
          data: 'package:${await _getPackageName()}',
        );
        await intent.launch();
      }
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }
}
