import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/common/location_util.dart';
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

import '../../../common/app_log_util.dart';

enum UserState { IDEAL, WORKING, NOT_WORKING }

class OptionModel {
  String label;
  IconData iconData;
  OptionModel({required this.label, required this.iconData});
}

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
  RxString distance = "0 m".obs;
  RxString version = "".obs;

  Rx<AttandanceModel> attandanceObj = AttandanceModel().obs;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    getTodaysSchedules();
    startObs();
    getVersion();
  }

  bool isAgent() {
    if (userData.value.login?.role?.toLowerCase() == "manager" ||
        userData.value.login?.role?.toLowerCase() == "admin") {
      return false;
    } else {
      return true;
    }
  }

  List<OptionModel> getMoreOptionList() {
    if (!isAgent()) {
      return [
        OptionModel(label: "Manage Schedules", iconData: Icons.manage_accounts),
        OptionModel(label: "Change Password", iconData: Icons.manage_accounts),
        OptionModel(label: "Logout", iconData: Icons.logout_outlined),
      ];
    } else {
      return [
        OptionModel(label: "Change Password", iconData: Icons.manage_accounts),
        OptionModel(label: "Logout", iconData: Icons.logout_outlined),
      ];
    }
  }

  void startObs() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (userManager.getIsWorking() == true) {
        if (kProfileMode | kReleaseMode) {
          getEmployeeTravelDistance();
        }
      }
    });
  }

  void loadUserData() async {
    await userManager.initPreferences();
    userData.value = userManager.getUserData() ?? LoginResponse();
    getEmployeeAttandance();
    print('loadUserData()${userData.value.toJson()}');
  }

  void getInLocation() {
    if (isPunchInProgress.isTrue) {
      return;
    }
    LocationUtil.getLocation((location) async {
      inLocation = location;
      await _cLockIN();
      isPunchInProgress.value = false;
    });
  }

  bool isSchedulePending() {
    return scheduleList
        .filter((s) => s.isVisitDone == 0 && s.isAuthorized == "Authorized")
        .toList()
        .isNotEmpty;

    // return scheduleList.any((item) {
    //   return item.isVisitDone == 0 && item.isAuthorized == "Authorized";
    // });
  }

  bool is15ScheduleCompleted() {
    var count = 0;
    count = scheduleList
        .filter(
          (s) => s.isVisitDone == 1 || s.isAuthorized == "Cancel Accepted",
        )
        .toList()
        .length;
    return count > 14;
  }

  void getOutLocation() {
    isPunchOutProgress.value = true;
    LocationUtil.getLocation((location) async {
      outLocation = location;
      await _clockOut();
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
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
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
      if (response.responseCode?.toLowerCase() == "success") {
        AppToast.showToast(message: "Clock out");
        userManager.setIsWorking(false);
        if (response.results != null && response.results!.isNotEmpty) {
          attandanceObj.value = response.results!.first;
          if (attandanceObj.value.isLoggedIn &&
              attandanceObj.value.isLoggedOut) {
            userState.value = UserState.NOT_WORKING;
            _stopForgrundService();
          }
        }
      } else {
        AppToast.showToast(
          message: response.responseCode ?? "Failed to clock out",
        );
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to clock out";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
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
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
    } catch (e) {
      AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> getEmployeeTravelDistance() async {
    // if (userManager.getIsWorking() == false) {
    //   return;
    // }
    aLog("getEmployeeTravelDistance()");

    isLoding.value = true;
    final request = GetDistanceRequest(
      userName: userManager.getUserData()?.login?.userName,
      date: DateFormatter.currentDate,
    );
    try {
      final response = await _employeeService.getEmployeeTravelDistance(
        request,
      );
      aLog("response::${response.results}");
      if (response.results != null && response.results!.isNotEmpty) {
        distance.value = "${response.results!.first.toStringAsFixed(2)} m";
      } else {
        distance.value = "0 m";
      }
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message  );
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message );
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> getEmployeeAttandance() async {
    isLoding.value = true;
    final request = GetDistanceRequest(
      userName: userData.value.login?.userName,
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
      print("userState:::${userState.value}");
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message);
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
      // AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message);
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
      // AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message );
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
      if (kProfileMode) {
        locationService.startTracking();
      }
      // _locationService.startBackgroundLocation();
    } else {
      // locationService.stopTracking();
      // _locationService.stopBackgroundLocation();
    }
  }

  void _stopForgrundService() {
    print("_stopForgrundService()");
    if (kProfileMode) {
      locationService.stopTracking();
    }
  }

  Future<void> getVersion() async {
    String version = "1.0.0.t_v_10";
    // version = Platform.isAndroid
    //     ? await getAndroidVersion()
    //     : await getiOSVersion();
    this.version.value = version;
  }

  Future<String> getAndroidVersion() async {
    const channel = MethodChannel('flutter.native/helper');
    try {
      return await channel.invokeMethod('getAppVersion');
    } on PlatformException {
      return 'Unknown';
    }
  }

  Future<String> getiOSVersion() async {
    const channel = MethodChannel('flutter.native/helper');
    try {
      final result = await channel.invokeMethod('getAppVersion');
      return result;
    } on PlatformException {
      return 'Unknown';
    }
  }
}
