import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/user_manager.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/navigation/app_pages.dart';

class DashboardController extends GetxController {
  final UserManager _userManager = Get.find();
  final EmployeeServiceProtocol _employeeService = Get.find();

  LocationLatLon inLocation = LocationLatLon();
  LocationLatLon outLocation = LocationLatLon();

  final RxBool isObscureNewPassword = true.obs;
  RxBool isLoding = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;

  RxBool punchIn = false.obs;
  RxString distance = "0km".obs;
  Position? _currentPosition;

  Future<void> _refreshLocation() async {
    try {
      // Check permissions
      final status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('Location permission denied');
      }
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _currentPosition = position;
    } catch (e) {
      //show bottom sheet error for need of location permission
      AppToast.showToast(message: 'Failed to get location: ${e.toString()}');
    } finally {}
  }

  void getInLocation(){
    _refreshLocation().then((_) {
      if (_currentPosition != null) {
        inLocation = LocationLatLon(
          lat: _currentPosition!.latitude,
          long: _currentPosition!.longitude,
        );
        cLockIN();
        // updateEmployeeRoute();
        getEmployeeTravelDistance();
      } else {
        AppToast.showToast(message: 'Failed to get in location');
      }
    });
  }


  void getOutLocation(){
    _refreshLocation().then((_) {
      if (_currentPosition != null) {
        inLocation = LocationLatLon(
          lat: _currentPosition!.latitude,
          long: _currentPosition!.longitude,
        );

        clockOut();
      } else {
        AppToast.showToast(message: 'Failed to get in location');
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void punchUpdate() {
    punchIn.value = !punchIn.value;
    if (punchIn.value) {
      AppToast.showToast(message: "Punch In Successful");
    } else {
      AppToast.showToast(message: "Punch Out Successful");
    }
  }

  void loadUserData() {
    userData.value = _userManager.getUserData() ?? LoginResponse();
  }

  Future<void> cLockIN() async {
    isLoding.value = true;
    final ClockRequest loginData = ClockRequest(
      userName: _userManager.getUserData()?.login?.userName,
      loginLat: inLocation.lat.toString(),
      loginLong: inLocation.long.toString(),
    );
    try {
      final response = await _employeeService.clockIn(loginData);
      punchUpdate();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update password";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> clockOut() async {
    isLoding.value = true;
    final ClockRequest loginData = ClockRequest(
      id: _userManager.getUserData()?.login?.id,
      userName: _userManager.getUserData()?.login?.userName,
      loginTime: DateFormatter.getCurrentDateTimeString(),
      loginLat: inLocation.lat.toString(),
      loginLong: inLocation.long.toString(),
      logoutLat: outLocation.lat.toString(),
      logoutLong: outLocation.long.toString(),
    );
    try {
      final response = await _employeeService.clockOut(loginData);
      punchUpdate();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update password";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> updateEmployeeRoute() async {
    isLoding.value = true;
    final request = [
      UserDateLatRequest(
        userName: _userManager.getUserData()?.login?.userName,
        loginTime: DateFormatter.getCurrentDateTimeString(),
        lat: inLocation.lat,
        lng: inLocation.long,
      ),
    ];
    try {
      final response = await _employeeService.employeeRouteUpdate(request);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update password";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> getEmployeeTravelDistance() async {
    isLoding.value = true;
    final request = GetDistanceRequest(
      userName: _userManager.getUserData()?.login?.userName,
      date: DateFormatter.currentDate,
    );
    try {
      final response = await _employeeService.getEmployeeTravelDistance(
        request,
      );
      if (response.results != null && response.results!.isNotEmpty) {
        distance.value = "${response.results!.first.toStringAsFixed(2)} km";
      } else {
        distance.value = "0 km";
      }
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> getEmployeeAttandance() async {
    isLoding.value = true;
    final request = GetDistanceRequest(
      userName: _userManager.getUserData()?.login?.userName,
      date: DateFormatter.currentDate,
    );
    try {
      final response = await _employeeService.getEmployeeAttandance(request);
      if (response.results != null && response.results!.isNotEmpty) {
        distance.value = "${response.results!.first.toStringAsFixed(2)} km";
      } else {
        distance.value = "0 km";
      }
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  // Future<void> requestLogin() async {
  //   if (isLoginButtonLoading.value == true) {
  //     return;
  //   }
  //   if(loginEmailCtr.text.isEmpty || loginPasswordCtr.text.isEmpty) {
  //     formKey.currentState?.validate();
  //     return;
  //   }

  //   isLoginButtonLoading.value = true;
  //   final LoginRequest loginData = LoginRequest(
  //     userName: loginEmailCtr.text,
  //     password: loginPasswordCtr.text,
  //   );
  //   await callDataService<Either<Object, APIResponse<LoginResponse>>>(
  //     _authService.getLoginResponse(loginData),
  //     onSuccess: (value) {
  //       value.fold(
  //         (l) => {isLoginButtonLoading.value = false},
  //         (r) async => {
  //           // await Future.delayed(Duration(seconds: 5)),
  //           isLoginButtonLoading.value = false,
  //           _userManager.setIsUserLoggedIn(true),
  //           _userManager.setUserData(r.response),
  //           _userManager.setUserToken(r.response.token),
  //           _userManager.setUserId(r.response.login?.id.toString()),
  //           ApplicationState().userLoggedIn(),
  //           Get.offAllNamed(Routes.bottomNavigation),
  //         },
  //       );
  //     },
  //     onError: (exception, {statusCode}) {
  //       isLoginButtonLoading.value = false;
  //       if (statusCode == 400) {
  //         AppToast.showToast(message: AppConstants.loginError);
  //       } else {
  //         AppToast.showToast();
  //       }
  //     },
  //   );
  // }

  // Future<void> getForgotPasswordStatus() async {
  //     await callDataService<int>(
  //       _service.forgotPassword(email: forgotPasswordEmailController.text),
  //       onSuccess: (value) {
  //         if (value == 200) {
  //           isForgotPasswordLoading.value = false;
  //           controller.fromForgotPassword.value = true;
  //           newPasswordValue.value = "";
  //           confirmPasswordValue.value = "";
  //           Get.to(const NewPasswordView());
  //           controller.secondsRemaining.value = 120;
  //           controller.startTimer();
  //         }
  //       },
  //       onError: (error, {statusCode}) {
  //         isForgotPasswordLoading.value = false;
  //         if (statusCode == 400) {
  //           AppToast.showToast(message: 'Email not registered');
  //         } else {
  //           AppToast.showToast(message: 'Something went Wrong');
  //         }
  //       },
  //     );
  //   }
  // }
  void logout() {
    _userManager.logOut();
    ApplicationState().userLoggedOut();
    Get.offAllNamed(Routes.login);
  }
}
