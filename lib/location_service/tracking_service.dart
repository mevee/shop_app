import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:workmanager/workmanager.dart';

// class LocationTrackingService extends GetxService {
class LocationTrackingService extends GetxService {
  final EmployeeServiceProtocol employeeService = EmployeeService();
  final RxList<Map<String, dynamic>> locations = <Map<String, dynamic>>[].obs;
  final RxString lastSyncStatus = 'Not started'.obs;
  final RxString lastError = ''.obs;
  final RxBool isTracking = false.obs;
  final RxInt syncCount = 0.obs;

  Timer? _syncTimer;
  Timer? _locationTimer;

  static const String _prefsKey = 'location_logs';
  static const int syncInterval = 4 * 60; // 4 minutes in seconds

  @override
  void onInit() {
    super.onInit();
    _loadLocationsFromPrefs();
  }

  Future<void> startTracking() async {
    if (isTracking.value) return;

    isTracking.value = true;
    lastSyncStatus.value = 'Tracking started';

    // Request location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      lastError.value = 'Location services are disabled';
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        lastError.value = 'Location permissions denied';
        return;
      }
    }

    // Start periodic location updates
    _locationTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        final newLocation = {
          'lat': position.latitude,
          'lng': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
        };

        locations.add(newLocation);
        await _saveLocationsToPrefs();
      } catch (e) {
        lastError.value = 'Location error: ${e.toString()}';
      }
    });

    // Start periodic sync
    _syncTimer = Timer.periodic(Duration(minutes: 4), (timer) async {
      await _syncLocationsWithServer();
    });

    // Initial sync
    await _syncLocationsWithServer();
  }

  Future<void> stopTracking() async {
    _locationTimer?.cancel();
    _syncTimer?.cancel();
    isTracking.value = false;
    lastSyncStatus.value = 'Tracking stopped';
    await _syncLocationsWithServer(); // Final sync before stopping
  }

  Future<void> _syncLocationsWithServer() async {
    if (locations.isEmpty) {
      lastSyncStatus.value = 'No locations to sync';
      return;
    }

    try {
      lastSyncStatus.value = 'Syncing...';
      // Get your token from shared preferences
      final working = Get.find<SPrefSessiomImpl>().getIsWorking();
      final userName = Get.find<SPrefSessiomImpl>()
          .getUserData()
          ?.login
          ?.userName;
      if (userName == null || userName.isEmpty) {
        lastError.value = 'User not authenticated';
        return;
      }
      if (working == null || working == false) {
        lastError.value = 'User not working';
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

  Future<void> _loadLocationsFromPrefs() async {
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

  @override
  void onClose() {
    _locationTimer?.cancel();
    _syncTimer?.cancel();
    super.onClose();
  }

  void startBackgroundLocation() {
    print("startBackgroundLocation()");
    Workmanager().registerPeriodicTask(
      "locationTask",
      "fetchLocation",
      frequency: Duration(minutes: 1),
    );
  }

  // Call this when user disables tracking
  void stopBackgroundLocation() {
    print("stopBackgroundLocation()");
    Workmanager().cancelByTag("locationTask");
  }
}
