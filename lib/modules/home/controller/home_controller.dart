import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/location_service/bg_service.dart';
import 'package:shop_app/location_service/tracking_service.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/navigation/app_pages.dart';

enum UserState { IDEAL, WORKING, NOT_WORKING }

class HomeController extends BaseController {
  final EmployeeServiceProtocol _employeeService = Get.find();
  final ScheduleServiceProtocol _scheduleService = Get.find();
  final LoginServiceProtocol _loginService = Get.find();
  final LocationSyncService syncService = Get.put(LocationSyncService());
  final FlutterBgService locationService = FlutterBgService();
  LocationLatLon inLocation = LocationLatLon();
  LocationLatLon outLocation = LocationLatLon();

  final RxBool isObscureNewPassword = true.obs;
  RxBool isTodaysLoding = false.obs;
  RxBool isLoding = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;

  RxBool isPunchInProgress = false.obs;
  RxBool isPunchOutProgress = false.obs;

  Rx<UserState> userState = UserState.IDEAL.obs;
  RxString distance = "0km".obs;

  Rx<AttandanceModel> attandanceObj = AttandanceModel().obs;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  Timer? _timer;


  @override
  void onInit() {
    super.onInit();
    loadUserData();
    getTodaysSchedules();
    startObs();
  }

  void startObs() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
       if(userManager.getIsWorking()==true){
         getEmployeeTravelDistance();
       }
    });
  }

  void loadUserData() async {
    await userManager.initPreferences();
    userData.value = userManager.getUserData() ?? LoginResponse();
    getEmployeeAttandance();
  }

  void getInLocation() {
    if (isPunchInProgress.isTrue) {
      return;
    }
    refreshLocation().then((_) async {
      if (currentPosition != null) {
        inLocation = LocationLatLon(
          lat: currentPosition!.latitude,
          long: currentPosition!.longitude,
        );
        await _cLockIN();
      } else {
        AppToast.showToast(message: 'Failed to get in location');
      }
    });
  }

  void getOutLocation() {
    isPunchOutProgress.value = true;
    refreshLocation().then((_) {
      if (currentPosition != null) {
        outLocation = LocationLatLon(
          lat: currentPosition!.latitude,
          long: currentPosition!.longitude,
        );
        _clockOut();
      } else {
        AppToast.showToast(message: 'Failed to get in location');
      }
      isPunchOutProgress.value = false;
    });
  }

  Future<void> _cLockIN() async {
    isPunchInProgress.value = true;
    final ClockInRequest loginData = ClockInRequest(
      username: userManager.getUserData()?.login?.userName,
      loginLat: inLocation.lat.toString(),
      loginLong: inLocation.long.toString(),
    );
    try {
      final response = await _employeeService.clockIn(loginData);
      if (response.responseCode?.toLowerCase() == "Fail".toLowerCase()) {
        AppToast.showToast(message: response.responseCode ?? "Punch In Failed");
      } else {
        AppToast.showToast(
          message: response.responseCode ?? "Punch In Sucessful",
        );
        if (response.results != null && response.results!.isNotEmpty) {
          attandanceObj.value = response.results!.first;
          if (attandanceObj.value.isLoggedIn &&
              !attandanceObj.value.isLoggedOut) {
            userState.value = UserState.WORKING;
            userManager.setIsWorking(true);
            _startForgrundService();
          }
        }
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to Punch In";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Punch In");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Punch In");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isPunchInProgress.value = false;
    }
  }

  Future<void> _clockOut() async {
    isPunchOutProgress.value = true;

    final ClockRequest loginData = ClockRequest(
      id: attandanceObj.value.id,
      username: userManager.getUserData()?.login?.userName,
      loginTime: DateFormatter.getCurrentDateTimeString(),
      loginLat: inLocation.lat.toString(),
      loginLong: inLocation.long.toString(),
      logoutLat: outLocation.lat.toString(),
      logoutLong: outLocation.long.toString(),
    );
    try {
      final response = await _employeeService.clockOut(loginData);
      if(response.responseCode?.toLowerCase()=="success"){
        AppToast.showToast(message: "Clock out");
        userManager.setIsWorking(false);
      }else{
        AppToast.showToast(message: response.responseCode??"Failed to clock out");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to clock out";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to clock out");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to clock out");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isPunchOutProgress.value = false;
    }
  }

  Future<void> updateEmployeeRoute() async {
    isLoding.value = true;
    final request = [
      UserDateLatRequest(
        userName: userManager.getUserData()?.login?.userName,
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
    if(userManager.getIsWorking()==false) {
      return;
    }
    isLoding.value = true;
    final request = GetDistanceRequest(
      userName: userManager.getUserData()?.login?.userName,
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
      userName: userManager.getUserData()?.login?.userName,
      date: DateFormatter.currentDate,
    );
    try {
      final response = await _employeeService.getEmployeeAttandance(request);
      if (response.results != null) {
        if (response.results!.isNotEmpty == true) {
          attandanceObj.value = response.results!.first;
          isPunchInProgress.refresh();
          isPunchOutProgress.refresh();

          if (attandanceObj.value.isLoggedIn) {
            if (attandanceObj.value.isLoggedOut == false) {
              userState.value = UserState.WORKING;
              userManager.setIsWorking(true);
              _startForgrundService();
            } else {
              userState.value = UserState.NOT_WORKING;
              userManager.setIsWorking(false);
            }
          } else {
            userManager.setIsWorking(false);
            userState.value = UserState.IDEAL;
          }
        } else {
          userState.value = UserState.IDEAL;
          attandanceObj.value.id = -1;
          userManager.setIsWorking(false);
          // attandanceObj.value.isLoggedIn =
        }
      }
      getEmployeeTravelDistance();

      print("userState:::${userState.value}");
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

  Future<void> getTodaysSchedules() async {
    isTodaysLoding.value = true;
    try {
      final response = await _scheduleService.getScheduleByDate(
        DateFormatter.currentDate,
      );
      if (response.results != null && response.results!.isNotEmpty) {
        scheduleList.value = response.results!;
      } else {
        scheduleList.value = [];
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
      isTodaysLoding.value = false;
    }
  }

  Future<void> logout() async {
    isLoding.value = true;
    try {
      final response = await _loginService.logoutFromApp(
        LoginRequest(userName: "0", password: "0"),
      );
      if (response.responseCode != null && response.responseCode == "fail") {
        AppToast.showToast(message: "Logout failed");
      } else {
        _logout();
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

  void _logout() {
    userManager.logOut();
    Get.offAllNamed(Routes.login);
  }

  void _startForgrundService() {
    print("_startForgrundService()");
    if (userManager.getIsWorking() == true) {
      locationService.startTracking();
      // _locationService.startBackgroundLocation();
    } else {
      // locationService.stopTracking();
      // _locationService.stopBackgroundLocation();
    }
  }
}
