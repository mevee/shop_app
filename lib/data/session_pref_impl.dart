import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/data/meeting_model.dart';
import 'package:shop_app/data/pref_util.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/models/login_response.dart';

class SPrefSessiomImpl with SessionPref {
  SharedPreferences? _prefs;
  SPrefSessiomImpl() {
    initPreferences();
  }
  @override
  Future<void> initPreferences() async {
    // _prefs = await SharedPreferences.getInstance();
    await PreferenceManager.initialize();
    _prefs = PreferenceManager.getPref();
  }

  @override
  LoginRequest? getSavedCred() {
    final userDataString = _prefs?.getString(UserManagerKeys.userCred.value);
    try {
      if (userDataString == null ||
          userDataString == "" ||
          userDataString.isEmpty ||
          userDataString == "null" ||
          userDataString == "Null") {
        return null;
      } else {
        final Map<String, dynamic> userMap = jsonDecode(userDataString);
        return LoginRequest.fromJson(userMap);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  LoginResponse? getUserData() {
    final userDataString = _prefs?.getString(UserManagerKeys.userData.value);
    try {
      if (userDataString == null ||
          userDataString == "" ||
          userDataString.isEmpty ||
          userDataString == "null" ||
          userDataString == "Null") {
        return null;
      } else {
        final Map<String, dynamic> userMap = jsonDecode(userDataString);
        return LoginResponse.fromJson(userMap);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  String? getUserId() {
    return _prefs?.getString(UserManagerKeys.userId.value);
  }

  @override
  String? getUserToken() {
    return _prefs?.getString(UserManagerKeys.userAccessToken.value);
  }

  @override
  isClockedIn() {
    return _prefs?.getBool(UserManagerKeys.userClockedIn.value);
  }

  @override
  isUserLoggedIn() {
    return _prefs?.getBool(UserManagerKeys.userLoggedIn.value);
  }

  @override
  bool? isRememberOn() {
    return _prefs?.getBool(UserManagerKeys.userCredRememeber.value);
  }

  @override
  void setClockedIn(bool? value) {
    _prefs?.setBool(UserManagerKeys.userClockedIn.value, value ?? false);
  }

  @override
  void setRememberOn(bool? value) {
    _prefs?.setBool(UserManagerKeys.userCredRememeber.value, value ?? false);
  }

  @override
  void setIsUserLoggedIn(bool? value) {
    _prefs?.setBool(UserManagerKeys.userLoggedIn.value, value ?? false);
  }

  @override
  void setUserData(LoginResponse? data) {
    if (data == null) {
      _prefs?.setString(UserManagerKeys.userData.value, "");
      return;
    }
    try {
      final String jsonString = jsonEncode(data);
      _prefs?.setString(UserManagerKeys.userData.value, jsonString);
    } on Exception catch (_) {
      _prefs?.setString(UserManagerKeys.userData.value, "");
    }
  }

  @override
  void saveUserCred(LoginRequest? data) {
    if (data == null) {
      _prefs?.setString(UserManagerKeys.userCred.value, "");
      return;
    }
    try {
      final String jsonString = jsonEncode(data);
      _prefs?.setString(UserManagerKeys.userCred.value, jsonString);
      // print("saveUserCred()$jsonString");
    } on Exception catch (e) {
      _prefs?.setString(UserManagerKeys.userCred.value, "");
      print("saveUserCredErr:while saving cred$e");
    }
  }

  @override
  void setUserId(String? value) {
    _prefs?.setString(UserManagerKeys.userId.value, value ?? "");
  }

  @override
  void setUserToken(String? token) {
    _prefs?.setString(UserManagerKeys.userAccessToken.value, token ?? "");
  }

  @override
  String? getTestData() {
    return _prefs?.getString(UserManagerKeys.testData.value) ?? "";
  }

  @override
  void setTestData(String? data) {
    _prefs?.setString(UserManagerKeys.testData.value, data ?? "");
  }

  @override
  void logOut() async {
    setClockedIn(false);
    setUserToken(null);
    setUserId(null);
    setIsUserLoggedIn(false);
    setUserData(null);
    setIsWorking(false);
    await clearAllMeetingSessions();
  }

  Future<void> _clear(String key) async {
    await _prefs?.clear();
  }

  @override
  bool? getIsWorking() {
    return _prefs?.getBool(UserManagerKeys.working.value) ?? false;
  }

  @override
  void setIsWorking(bool? value) {
    _prefs?.setBool(UserManagerKeys.working.value, value ?? false);
  }

  // --- Meeting Session Functions ---

  Map<String, MeetingData>? _getRawMeetingSessions() {
    final String? meetingsJsonString = _prefs?.getString(
      UserManagerKeys.meetingsData.value,
    );
    if (meetingsJsonString == null || meetingsJsonString.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> decodedMap = jsonDecode(meetingsJsonString);
      return decodedMap.map(
        (key, value) =>
            MapEntry(key, MeetingData.fromJson(value as Map<String, dynamic>)),
      );
    } catch (e) {
      print("Error decoding meeting sessions: $e");
      return null;
    }
  }

  Future<void> _saveRawMeetingSessions(
    Map<String, MeetingData> meetings,
  ) async {
    final Map<String, dynamic> jsonMap = meetings.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    final String encodedString = jsonEncode(jsonMap);
    await _prefs?.setString(UserManagerKeys.meetingsData.value, encodedString);
  }

  @override
  Future<void> saveMeetingSession(String meetingId, MeetingData data) async {
    final Map<String, MeetingData> currentMeetings =
        _getRawMeetingSessions() ?? {};
    currentMeetings[meetingId] = data;
    await _saveRawMeetingSessions(currentMeetings);
  }

  @override
  MeetingData? getMeetingSession(String meetingId) {
    final Map<String, MeetingData>? currentMeetings = _getRawMeetingSessions();
    return currentMeetings?[meetingId];
  }

  @override
  Future<void> removeMeetingSession(String meetingId) async {
    final Map<String, MeetingData>? currentMeetings = _getRawMeetingSessions();
    if (currentMeetings != null && currentMeetings.containsKey(meetingId)) {
      currentMeetings.remove(meetingId);
      await _saveRawMeetingSessions(currentMeetings);
    }
  }

  @override
  Map<String, MeetingData>? getAllMeetingSessions() {
    return _getRawMeetingSessions();
  }

  @override
  Future<void> clearAllMeetingSessions() async {
    await _prefs?.remove(UserManagerKeys.meetingsData.value);
  }

  // --- New Function to check a single meeting's duration completion ---
  @override
  bool isMeetingCompletedMinDuration(String meetingId, int minDurationMinutes) {
    final MeetingData? meetingData = getMeetingSession(meetingId);

    if (meetingData == null) {
      return false; // Meeting not found or start time not recorded
    }

    final int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final int requiredDurationMillis = minDurationMinutes * 60 * 1000;

    final int elapsedMillis = currentTimeMillis - meetingData.startTimeMillis;

    return elapsedMillis >= requiredDurationMillis;
  }
}
