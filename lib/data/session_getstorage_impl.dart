// import 'dart:convert';

// import 'package:get_storage/get_storage.dart';
// import 'package:shop_app/data/preference.dart';
// import 'package:shop_app/models/login_response.dart';

// class GetPrefManagerImpl with SessionPref {
//   @override
//   LoginResponse? getUserData() {
//     final userDataString = GetStorage().read(UserManagerKeys.userData.value);
//     try {
//       if (userDataString == "" || userDataString == null) {
//         return LoginResponse();
//       }
//       final Map<String, dynamic> userMap = jsonDecode(userDataString);
//       return LoginResponse.fromJson(userMap);
//     } on Exception catch (_) {
//       return LoginResponse();
//     }
//   }

//   @override
//   String? getUserId() {
//    return GetStorage().read(UserManagerKeys.userId.value);
//   }

//   @override
//   String? getUserToken() {
//    return GetStorage().read(UserManagerKeys.userAccessToken.value);
//   }

//   @override
//   isClockedIn() {
//      return GetStorage().read(UserManagerKeys.userClockedIn.value);
//   }

//   @override
//   isUserLoggedIn() {
//     return GetStorage().read(UserManagerKeys.userLoggedIn.value);
//   }

//   @override
//   void setClockedIn(bool? value) {
//     GetStorage().write(UserManagerKeys.userClockedIn.value, value);
//   }

//   @override
//   void setIsUserLoggedIn(bool? value) {
//     GetStorage().write(UserManagerKeys.userLoggedIn.value, value);
//   }

//   @override
//   void setUserData(LoginResponse? data) {
//     try {
//       final String jsonString = jsonEncode(data);
//       GetStorage().write(UserManagerKeys.userData.value, jsonString);
//     } on Exception catch (_) {
//       GetStorage().write(UserManagerKeys.userData.value, null);
//     }
//   }

//   @override
//   void setUserId(String? value) {
//     GetStorage().write(UserManagerKeys.userId.value, value);
//   }

//   @override
//   void setUserToken(String? token) {
//     GetStorage().write(UserManagerKeys.userAccessToken.value, token);
//   }
//   // dynamic get isUserLoggedIn =>
//   //     GetStorage().read(UserManagerKeys.userLoggedIn.value);

//   // void setIsUserLoggedIn(bool? value) =>
//   //     GetStorage().write(UserManagerKeys.userLoggedIn.value, value);

//   // String? get getUserToken =>
//   //     GetStorage().read(UserManagerKeys.userAccessToken.value);
 
//   // String? get getUserId => GetStorage().read(UserManagerKeys.userId.value);

  
//   @override
//   void logOut() {
//     setClockedIn(false);
//     setUserToken(null);
//     setUserId(null);
//     setIsUserLoggedIn(false);
//     setUserData(null);
//   }
  
//   @override
//   Future<void> initPreferences() {

//     return Future.value();
//   }
// }
