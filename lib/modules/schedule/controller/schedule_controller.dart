import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/user_manager.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/navigation/app_pages.dart';

class ScheduleController extends BaseController {
  final UserManager _userManager = Get.find();
  final ScheduleServiceProtocol scheduleService = Get.find();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController existingQuantityController =
      TextEditingController();
  final TextEditingController newOrderQuantityController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  LocationLatLon inLocation = LocationLatLon();
  LocationLatLon outLocation = LocationLatLon();

  RxBool isLoding = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;
 
  RxList<ShopMasterResponse> shopDetailsOptions = <ShopMasterResponse>[].obs;
  Rx<ShopMasterResponse?> selectedShop = null.obs;
  int? scheduleId;

  String? scheduleDate;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? data = Get.arguments;
    if (data?.containsKey('id')==true) {
      scheduleId = data?['id']!;
      getScheduleDetails(scheduleId);
    }
    else if (data?.containsKey('date')==true) {
      scheduleDate = data?['date']!;
      getTodaysScheduleList(scheduleDate);
    }
    loadUserData();
    //getShopList();
  }

  Future<void> getTodaysScheduleList(String? date) async {
    isLoding.value = true;
    try {
      final response = await scheduleService.getScheduleByDate(date);
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
      isLoding.value = false;
    }
  }

Future<void> getScheduleDetails(int? scheduleId) async {
    isLoding.value = true;
    try {
      final response = await scheduleService.getScheduleDetails("$scheduleId");
      if (response.results != null && response.results!.isNotEmpty) {
        // scheduleList.value = response.results!.first;
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
  void loadUserData() {
    userData.value = _userManager.getUserData() ?? LoginResponse();
  }

  // Future<void> clockOut() async {
  //   isLoding.value = true;
  //   final ClockRequest loginData = ClockRequest(
  //     id: _userManager.getUserData()?.login?.id,
  //     userName: _userManager.getUserData()?.login?.userName,
  //     loginTime: DateFormatter.getCurrentDateTimeString(),
  //     loginLat: inLocation.lat.toString(),
  //     loginLong: inLocation.long.toString(),
  //     logoutLat: outLocation.lat.toString(),
  //     logoutLong: outLocation.long.toString(),
  //   );
  //   try {
  //     final response = await _employeeService.clockOut(loginData);
  //     punchUpdate();
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         e.response?.data['error'] ?? "Failed to update password";
  //     AppToast.showToast(message: errorMessage);
  //   } on SocketException catch (e) {
  //     AppToast.showToast(message: e.message ?? "Failed to update Password");
  //   } on ServerException catch (e) {
  //     AppToast.showToast(message: e.message ?? "Failed to Update Password");
  //   } catch (e) {
  //     AppToast.showToast();
  //   } finally {
  //     isLoding.value = false;
  //   }
  // }

  // Future<void> updateEmployeeRoute() async {
  //   isLoding.value = true;
  //   final request = [
  //     UserDateLatRequest(
  //       userName: _userManager.getUserData()?.login?.userName,
  //       loginTime: DateFormatter.getCurrentDateTimeString(),
  //       lat: inLocation.lat,
  //       lng: inLocation.long,
  //     ),
  //   ];
  //   try {
  //     final response = await _employeeService.employeeRouteUpdate(request);
  //   } on DioException catch (e) {
  //     final errorMessage =
  //         e.response?.data['error'] ?? "Failed to update password";
  //     AppToast.showToast(message: errorMessage);
  //   } on SocketException catch (e) {
  //     AppToast.showToast(message: e.message ?? "Failed to update Password");
  //   } on ServerException catch (e) {
  //     AppToast.showToast(message: e.message ?? "Failed to Update Password");
  //   } catch (e) {
  //     AppToast.showToast();
  //   } finally {
  //     isLoding.value = false;
  //   }
  // }

  // Future<void> getEmployeeTravelDistance() async {
  //   isLoding.value = true;
  //   final request = GetDistanceRequest(
  //     userName: _userManager.getUserData()?.login?.userName,
  //     date: DateFormatter.currentDate,
  //   );
  //   try {
  //     final response = await _employeeService.getEmployeeTravelDistance(
  //       request,
  //     );
  //     if (response.results != null && response.results!.isNotEmpty) {
  //       distance.value = "${response.results!.first.toStringAsFixed(2)} km";
  //     } else {
  //       distance.value = "0 km";
  //     }
  //   } on DioException catch (e) {
  //     // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
  //     // AppToast.showToast(message: errorMessage);
  //   } on SocketException catch (e) {
  //     // AppToast.showToast(message: e.message ?? "Failed to update Password");
  //   } on ServerException catch (e) {
  //     // AppToast.showToast(message: e.message ?? "Failed to Update Password");
  //   } catch (e) {
  //     // AppToast.showToast();
  //   } finally {
  //     isLoding.value = false;
  //   }
  // }

  Future<void> getShopList() async {
    isLoding.value = true;
    try {
      final response = await scheduleService.getShopList();
      if (response.isNotEmpty) {
        shopDetailsOptions.value = response;
      } else {
        shopDetailsOptions.value = [];
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

  void logout() {
    _userManager.logOut();
    ApplicationState().userLoggedOut();
    Get.offAllNamed(Routes.login);
  }

  void submitForm() {
    // Basic validation
    if (dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        existingQuantityController.text.isEmpty ||
        newOrderQuantityController.text.isEmpty ||
        remarksController.text.isEmpty) {
      AppToast.showToast(message: 'Please fill all fields.');
      return;
    }
    // You can process the form data here
    final formData = {
      'date': dateController.text,
      'time': timeController.text,
      'shopDetails': selectedShop,
      'existingQuantity': existingQuantityController.text,
      'newOrderQuantity': newOrderQuantityController.text,
      'remarks': remarksController.text,
    };
    print('Form Data: $formData');
    AppToast.showToast(message: 'Form Submitted Successfully!');
    //  Clear fields after submission
    dateController.clear();
    timeController.clear();
    existingQuantityController.clear();
    newOrderQuantityController.clear();
    remarksController.clear();
    selectedShop.value = null;
    selectedDate = null;
    selectedTime = null;
  }
}
