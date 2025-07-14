import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:shop_app/models/login_response.dart';

enum UserManagerKeys {
  userLoggedIn("USER_LOGGED_IN"),
  userAccessToken("USER_TOKEN"),
  userId("USER_ID"),
  userData("USER_DATA");

  final String value;

  const UserManagerKeys(this.value);
}

class UserManager {
  dynamic get isUserLoggedIn =>
      GetStorage().read(UserManagerKeys.userLoggedIn.value);

  void setIsUserLoggedIn(bool? value) =>
      GetStorage().write(UserManagerKeys.userLoggedIn.value, value);

  LoginResponse? getUserData() {
    final userDataString = GetStorage().read(UserManagerKeys.userData.value);
    try {
      if (userDataString == "" || userDataString == null) {
        return LoginResponse();
      }
      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      return LoginResponse.fromJson(userMap);
    } on Exception catch (_) {
      return LoginResponse();
    }
  }

  void setUserData(LoginResponse? data) {
    try {
      final String jsonString = jsonEncode(data);
      GetStorage().write(UserManagerKeys.userData.value, jsonString);
    } on Exception catch (_) {
      GetStorage().write(UserManagerKeys.userData.value, null);
    }
  }

  String? get getUserToken =>
      GetStorage().read(UserManagerKeys.userAccessToken.value);

  void setUserToken(String? token) =>
      GetStorage().write(UserManagerKeys.userAccessToken.value, token);

  String? get getUserId => GetStorage().read(UserManagerKeys.userId.value);

  void setUserId(String? value) =>
      GetStorage().write(UserManagerKeys.userId.value, value);

  void logOut() {
    setUserToken(null);
    setUserId(null);
    setIsUserLoggedIn(false);
    setUserData(null);
  }
}
