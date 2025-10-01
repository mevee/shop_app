import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/models/login_response.dart';

class LocalDataSource {
  SessionPref client;
  LocalDataSource(this.client);

  Future<bool> isLogin() async {
    final response = await getSavedUser();
    return response != null;
  }

  Future<LoginResponse?> getSavedUser() async {
    try {
      final response = client.getUserData();
      return response;
    } catch (error) {
      aLog("Error in getting user data: $error");
      return null;
    }
  }

  Future<String?> getToken() async {
     final response = client.getUserToken();
    return response;
  }

  void logout() async {
    client.logOut();
  }
}
