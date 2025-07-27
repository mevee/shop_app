import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
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
import 'package:shop_app/models/update_schedule_request.dart';
import 'package:shop_app/navigation/app_pages.dart';

class ManagerController extends BaseController {
  final ScheduleServiceProtocol scheduleService = Get.find();

  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  ShopMasterModel? selectedShop;
  Rx<String> selectedShopStr = "Select Shop".obs;
  int? scheduleId;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  Rx<LoginResponse> user = LoginResponse().obs;

  @override
  void onInit() {
    super.onInit();
    getTodaysScheduleList(DateFormatter.currentDate);
    loadUserData();
  }

  Future<void> getTodaysScheduleList(String? date) async {
    isDataLoading.value = true;
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
      isDataLoading.value = false;
    }
  }

  void loadUserData() async {
    await userManager.initPreferences();
    user.value = userManager.getUserData() ?? LoginResponse();
  }

  void submitForm(ScheduleDateTimeModel schedule, String approveMessage) async {
    // Basic validation
    if (remarksController.text.isEmpty) {
      AppToast.showToast(message: 'Please fill all fields.');
      return;
    }
    AuthorizeRequest request = AuthorizeRequest(
        id: schedule.id,
        authorizedRemarks: approveMessage,
        isAuthorized: "Authorized"
    );
    print('Form Data: $request');
    try {
      isLoading.value=true;
      final response = await scheduleService.updateAuthorizeSchedule(request);
      if (response.responseCode?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to authorized.',
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
      isLoading.value = false;
    }
    remarksController.clear();
  }
}
