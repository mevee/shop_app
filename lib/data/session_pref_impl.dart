import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/models/login_response.dart';

class SharePrefSessiomImpl with SessionPref {
  SharedPreferences? _prefs;
  SharePrefSessiomImpl() {
    initPreferences();
  }
  @override
  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  LoginResponse? getUserData() {
    final userDataString = _prefs?.getString(UserManagerKeys.userData.value);
    try {
      if (userDataString == "" || userDataString == null) {
        return null;
      }
      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      return LoginResponse.fromJson(userMap);
    } on Exception catch (_) {
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
  void setClockedIn(bool? value) {
    _prefs?.setBool(UserManagerKeys.userClockedIn.value, value ?? false);
  }

  @override
  void setIsUserLoggedIn(bool? value) {
    _prefs?.setBool(UserManagerKeys.userLoggedIn.value, value ?? false);
  }

  @override
  void setUserData(LoginResponse? data) {
    try {
      final String jsonString = jsonEncode(data);
      _prefs?.setString(UserManagerKeys.userData.value, jsonString);
    } on Exception catch (_) {
      _prefs?.setString(UserManagerKeys.userData.value, "");
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
  void logOut() {
    setClockedIn(false);
    setUserToken(null);
    setUserId(null);
    setIsUserLoggedIn(false);
    setUserData(null);
  }


  Future<void> _clear(String key) async {
    await _prefs?.clear();
  }
}
