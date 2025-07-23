import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_schedule_request.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/navigation/app_pages.dart';

class ScheduleController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ScheduleServiceProtocol scheduleService = Get.find();
  final ShopMasterServiceProtocol masterService = Get.find();

  final TextEditingController searchCtr = TextEditingController();
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
  RxBool isDateWiseLoding = false.obs;
  RxBool isSearchLoading = false.obs;

  RxBool addScheduleLoding = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;

  RxList<ShopMasterModel> shopDetailsOptions = <ShopMasterModel>[].obs;

  final TextEditingController shopController = TextEditingController();
  ShopMasterModel? selectedShop;
  Rx<String> selectedShopStr = "Select Shop".obs;

  int? scheduleId;

  String? scheduleDate;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? data = Get.arguments;
    if (data?.containsKey('id') == true) {
      scheduleId = data?['id']!;
      getScheduleDetails(scheduleId);
    } else if (data?.containsKey('date') == true) {
      scheduleDate = data?['date']!;
      getTodaysScheduleList(scheduleDate);
    }
    loadUserData();
    //getShopList();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeController.text = TimeOfDay.now().format(Get.context!);
  }

  Future<void> getTodaysScheduleList(String? date) async {
    isDateWiseLoding.value = true;
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
      isDateWiseLoding.value = false;
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

  void loadUserData() async {
    await userManager.initPreferences();
    userData.value = userManager.getUserData() ?? LoginResponse();
  }

  void selectShop(ShopMasterModel shop) {
    selectedShop = shop;
    selectedShopStr.value = shop.unitName ?? "Select Shop";
    shopController.text = shop.unitName ?? 'Unknown Shop';
  }

  Completer? completer;

  Future<void> getShopList(String query) async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isSearchLoading.value = false;
    }

    if (query.isEmpty) {
      return;
    }
    completer = Completer();
    isSearchLoading.value = true;
    try {
      final future = masterService.getShopByName(query);
      completer?.complete(future);
      final response = await completer!.future;
      shopDetailsOptions.value = response.results ?? [];
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
      isSearchLoading.value = false;
    }
  }

  void logout() {
    _userManager.logOut();
    ApplicationState().userLoggedOut();
    Get.offAllNamed(Routes.login);
  }

  Future<void> addSchedule() async {
    if (dateController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a date.');
      return;
    }
    if (timeController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a time.');
      return;
    }
    if (selectedShop == null) {
      AppToast.showToast(message: 'Please select a shop.');
      return;
    }
    addScheduleLoding.value = true;
    final shop = selectedShop;
    final request = AddScheduleRequest(
      userName: userData.value.login?.userName,
      shopId: shop?.id.toString(),
      shopName: shop?.unitName,
      scheduleDateTime: '${dateController.text}T${timeController.text}', //todo
      status: "ACTIVE",
      createdBy: userData.value.login?.role,
      day: dateController.text,
      isVisitDone: 0,
    );
    try {
      final response = await scheduleService.addSchedule(request);
      if (response.responseCode?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to add schedule.',
        );
      } else {
        AppToast.showToast(message: 'Schedule added successfully!');
        Get.back(result: true); // Close the dialog and return true
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
      addScheduleLoding.value = false;
    }
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
    selectedShop = null;
    selectedDate = null;
    selectedTime = null;
  }
}
