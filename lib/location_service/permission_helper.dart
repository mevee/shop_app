import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import 'package:shop_app/common/app_toast.dart';

class PermissionUtil {
  /// Check if the platform is Android
  static bool get isAndroid => Platform.isAndroid;

  /// Check if the platform is iOS
  static bool get isIOS => Platform.isIOS;

  /// Request a permission and return status via callback
  static Future<void> requestPermission({
    required Permission permission,
    required Function(bool isGranted) onResult,
    String?
    rationale, // Optional message to explain why the permission is needed
  }) async {
    // Check if permission is already granted
    final status = await permission.status;

    if (status.isGranted) {
      onResult(true);
      return;
    }

    // Show rationale if needed (e.g., for Android)
    if (status.isDenied && rationale != null && isAndroid) {
      final shouldRequest = await _showRationaleDialog(rationale);
      if (!shouldRequest) {
        onResult(false);
        return;
      }
    }

    // Request the permission
    final newStatus = await permission.request();

    if (newStatus.isGranted) {
      onResult(true);
    } else if (newStatus.isPermanentlyDenied) {
      // Open app settings if permanently denied
      await openAppSettings();
      onResult(false);
    } else {
      onResult(false);
    }
  }

  /// Handle platform-specific permissions (e.g., Android 13+ notifications)
  static Future<bool> locationPermissionCheck() async {
    if (isAndroid) {
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        return Future.value(true);
      } else {
        final newStatus = await Permission.locationWhenInUse.request();
        if (newStatus.isGranted) {
          return Future.value(true);
        } else if (newStatus.isPermanentlyDenied) {
          await openAppSettings(); // Redirect to settings
          return Future.value(false);
        }
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  /// Handle platform-specific permissions (e.g., Android 13+ notifications)
  static Future<bool> notificationPermissionCheck() async {
    if (isAndroid) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        return Future.value(true);
      } else {
        final newStatus = await Permission.notification.request();
        if (newStatus.isGranted) {
          return Future.value(true);
        } else if (newStatus.isPermanentlyDenied) {
          await openAppSettings(); // Redirect to settings
          return Future.value(false);
        }
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  static Future<void> checkEssentialPermissions({
    required Function(bool allGranted) onResult,
    bool requestBackgroundLocation = false,
  }) async {
    final permissions = <Permission>[];

    // Common permissions (Android & iOS)
    permissions.addAll([
      Permission.locationWhenInUse,
      if (isAndroid) Permission.notification,
    ]);

    // Android-specific permissions
    if (isAndroid) {
      // Background location (Android 10+)
      if (requestBackgroundLocation) {
        permissions.add(Permission.locationAlways);
      }

      // Foreground service (Android 12+)
      permissions.add(Permission.manageExternalStorage);
    }

    // Check all permissions
    bool allGranted = true;
    for (final permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        allGranted = false;
        break;
      }
    }

    if (allGranted) {
      onResult(true);
    } else {
      // Request missing permissions
      final results = await permissions.request();
      final granted = results.values.every((status) => status.isGranted);
      onResult(granted);
    }
  }

  /// Show a rationale dialog (Android)
  static Future<bool> _showRationaleDialog(String message) async {
    // Implement a dialog (using `showDialog` or a package like `fluttertoast`)
    // Return `true` if the user agrees to proceed.
    AppToast.showToast(message: message);
    return true; // Simplified for example
  }

  /// Request notification permission (only for Android 13+)
  static Future<void> requestNotificationPermission({
    required Function(bool isGranted) onResult,
    String? rationale, // Optional explanation dialog
  }) async {
    // Skip if not Android or Android < 13
    if (!isAndroid || !(await isAndroid13OrHigher)) {
      onResult(true); // No need for permission on iOS or older Android
      return;
    }

    // Check current status
    final status = await Permission.notification.status;

    if (status.isGranted) {
      onResult(true);
      return;
    }

    // Show rationale if denied once (Android-specific)
    if (status.isDenied && rationale != null) {
      final shouldProceed = await _showRationaleDialog(rationale);
      if (!shouldProceed) {
        onResult(false);
        return;
      }
    }

    // Request permission
    final newStatus = await Permission.notification.request();

    if (newStatus.isGranted) {
      onResult(true);
    } else if (newStatus.isPermanentlyDenied) {
      await openAppSettings(); // Redirect to settings
      onResult(false);
    } else {
      onResult(false);
    }
  }

  /// Check if Android version is 13 (API 33) or higher
  static Future<bool> get isAndroid13OrHigher async {
    if (!isAndroid) return false;
    try {
      final version = await _getAndroidVersion();
      return version >= 33; // Android 13 = API 33
    } catch (e) {
      return false;
    }
  }

  /// Fetch Android SDK version
  static Future<int> _getAndroidVersion() async {
    final platformVersion = await MethodChannel(
      'android_info',
    ).invokeMethod('getAndroidVersion');
    return int.tryParse(platformVersion.toString()) ?? 0;
  }
}
