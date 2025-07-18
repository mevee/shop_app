import 'package:shop_app/models/login_response.dart';

enum UserManagerKeys {
  userClockedIn("USER_CLOCKED_IN"),
  userLoggedIn("USER_LOGGED_IN"),
  userAccessToken("USER_TOKEN"),
  userId("USER_ID"),
  userData("USER_DATA");

  final String value;
  const UserManagerKeys(this.value);
}

mixin SessionPref {
  Future<void> initPreferences();
  dynamic isClockedIn();
  void setClockedIn(bool? value);

  void setUserData(LoginResponse? data);
  LoginResponse? getUserData();
  dynamic isUserLoggedIn();
  void setIsUserLoggedIn(bool? value);

  String? getUserToken();
  void setUserToken(String? token);
  String? getUserId();
  void setUserId(String? value);
  void logOut();
}
