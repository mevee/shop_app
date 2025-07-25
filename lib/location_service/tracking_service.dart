import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/models/employee_response.dart';

class LocationSyncService {
  final EmployeeServiceProtocol employeeService = EmployeeService();
  final RxList<Map<String, dynamic>> locations = <Map<String, dynamic>>[].obs;
  final RxString lastSyncStatus = 'Not started'.obs;
  final RxString lastError = ''.obs;
  final RxInt syncCount = 0.obs;
  static const String _prefsKey = 'location_logs';

  Future<void> startRecording(Position position) async {
    lastSyncStatus.value = 'Tracking started';
    final newLocation = {
      'lat': position.latitude,
      'lng': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    };

    locations.add(newLocation);
    await _saveLocationsToPrefs(

    );

    // Initial sync
    await _syncLocationsWithServer();
  }

  Future<void> _syncLocationsWithServer() async {
    if (locations.isEmpty && locations.length > 4) {
      lastSyncStatus.value = 'No locations to sync';
      return;
    }
    try {
      lastSyncStatus.value = 'Syncing...';
      // Get your token from shared preferences
      final working = Get.find<SPrefSessiomImpl>().getIsWorking();
      if (working == null || working == false) {
        lastError.value = 'User not working';
        return;
      }
      final userName = Get.find<SPrefSessiomImpl>()
          .getUserData()
          ?.login
          ?.userName;
      if (userName == null || userName.isEmpty) {
        lastError.value = 'User not authenticated';
        return;
      }
      // Prepare data to send
      List<UserDateLatRequest> request = [];
      final locationsToSend = List<Map<String, dynamic>>.from(locations);
      locationsToSend.forEach(((e) {
        request.add(
          UserDateLatRequest(userName: userName, lat: e['lat'], lng: e['lng']),
        );
      }));
      final response = await employeeService.employeeRouteUpdate(request);
      if (response.responseCode?.toLowerCase() != "fail") {
        locations.removeRange(0, locationsToSend.length);
        await _saveLocationsToPrefs();
        syncCount.value++;
        lastSyncStatus.value = 'Last sync: ${DateTime.now()} - Success';
      } else {
        lastError.value = 'Sync failed: ${response.responseCode}';
      }
    } catch (e) {
      lastError.value = 'Sync error: ${e.toString()}';
    }
  }

  Future<void> _saveLocationsToPrefs() async {
    final working = Get.find<SPrefSessiomImpl>().getIsWorking();
    if (working != null && working) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(locations));
    }
  }

  Future<void> loadLocationsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final locationsJson = prefs.getString(_prefsKey);
    if (locationsJson != null && locationsJson.isNotEmpty) {
      try {
        final List<dynamic> parsed = jsonDecode(locationsJson);
        locations.assignAll(parsed.cast<Map<String, dynamic>>());
      } catch (e) {
        lastError.value = 'Failed to load locations: ${e.toString()}';
      }
    }
  }
}
