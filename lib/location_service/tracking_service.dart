import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/models/employee_response.dart';

class LocationSyncService {
  // final EmployeeServiceProtocol employeeService = EmployeeService();
  final SessionPref session = SPrefSessiomImpl();
  final List<UserDateLatRequest> locations = <UserDateLatRequest>[];
  String lastSyncStatus = 'Not started';
  String lastError = '';
  int syncCount = 0;
  static const String _prefsKey = 'location_logs';

  init() async {
    await session.initPreferences();
  }

  Future<void> startRecording(Position position) async {
    aLog("startRecording(${locations.length})");
    lastSyncStatus = 'Tracking started';
    final newLocation = UserDateLatRequest(
      userName: session.getUserData()?.login?.userName,
      lat: position.latitude,
      lng: position.longitude,
      createdDate: DateTime.now().toString().replaceAll(" ","T"),
    );
    aLog("newLocation($newLocation)");
    locations.add(newLocation);
    await _saveLocationsToPrefs();
  }

  List<UserDateLatRequest> getLocationsToBeSent() {
    return List<UserDateLatRequest>.from(locations);
  }

  Future<void> clerSyncedLocations(
    List<UserDateLatRequest> locationsSent,
  ) async {
    aLog("clerSyncedLocations()");

    if (locations.isEmpty && locations.length > 4) {
      lastSyncStatus = 'No locations to sync';
      return;
    }
    final working = session.getIsWorking();
    if (working == null || working == false) {
      lastError = 'User not working';
      return;
    }
    final userName = session.getUserData()?.login?.userName;
    if (userName == null || userName.isEmpty) {
      lastError = 'User not authenticated';
      return;
    }
    locations.removeRange(0, locationsSent.length);
    await _saveLocationsToPrefs();
    syncCount++;
  }

  // Future<void> _syncLocationsWithServer() async {
  //   if (locations.isEmpty && locations.length > 4) {
  //     lastSyncStatus = 'No locations to sync';
  //     return;
  //   }
  //   try {
  //     lastSyncStatus = 'Syncing...';
  //     // Get your token from shared preferences
  //     final session = SPrefSessiomImpl();
  //     await session.initPreferences();
  //     final working = session.getIsWorking();
  //     if (working == null || working == false) {
  //       lastError = 'User not working';
  //       return;
  //     }
  //     final userName = session.getUserData()?.login?.userName;
  //     if (userName == null || userName.isEmpty) {
  //       lastError = 'User not authenticated';
  //       return;
  //     }
  //     // Prepare data to send
  //     List<UserDateLatRequest> request = [];
  //     final locationsToSend = List<Map<String, dynamic>>.from(locations);
  //     locationsToSend.forEach(((e) {
  //       request.add(
  //         UserDateLatRequest(userName: userName, lat: e['lat'], lng: e['lng']),
  //       );
  //     }));
  //     final response = await employeeService.employeeRouteUpdate(request);
  //     if (response.responseCode?.toLowerCase() != "fail") {
  //       locations.removeRange(0, locationsToSend.length);
  //       await _saveLocationsToPrefs();
  //       syncCount++;
  //       lastSyncStatus = 'Last sync: ${DateTime.now()} - Success';
  //     } else {
  //       lastError = 'Sync failed: ${response.responseCode}';
  //     }
  //   } catch (e) {
  //     lastError = 'Sync error: ${e.toString()}';
  //   }
  // }

  Future<void> _saveLocationsToPrefs() async {
    aLog("_saveLocationsToPrefs()");

    final working = session.getIsWorking();
    if (working != null && working) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(locations));
    }
  }

  Future<void> loadLocationsFromPrefs() async {
    aLog("loadLocationsFromPrefs()");
    final prefs = await SharedPreferences.getInstance();
    final locationsJson = prefs.getString(_prefsKey);
    // aLog("locationsJson: $locationsJson");
    if (locationsJson != null && locationsJson.isNotEmpty) {
      try {
        final List<UserDateLatRequest> parsed = [];
        final List<dynamic> jsonList = jsonDecode(locationsJson);
        for (var item in jsonList) {
          if (item != null) {
            parsed.add(UserDateLatRequest.fromJson(item));
          }
        }
        // aLog("jsonList: $jsonList");
        aLog("parsed: $parsed");
        locations.clear();
        locations.assignAll(parsed);
        aLog("parsed: ${locations.length}");
      } catch (e) {
        aLog("Failed to load locations");
        // lastError = 'Failed to load locations: ${e.toString()}';
      }
    }
  }
}
