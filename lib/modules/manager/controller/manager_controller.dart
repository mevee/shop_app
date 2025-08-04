import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/manager_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/agent_list_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/models/schedule_request.dart';

class ManagerController extends BaseController {
  final ScheduleServiceProtocol scheduleService = Get.find();
  final ManagerServiceProtocol _manageService = Get.find();

  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isActionLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  ShopMasterModel? selectedShop;
  Rx<String> selectedShopStr = "Select Shop".obs;
  int? scheduleId;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  RxList<AgentModel> agentList = <AgentModel>[].obs;
  AgentModel? agent;
  RxString selectedAgent = "Select Agent".obs;
  Rx<LoginResponse> user = LoginResponse().obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    getAgentList();
  }

  Future<void> getTodaysScheduleList() async {
    scheduleList.value = [];
    isDataLoading.value = true;
    try {
      final response = await _manageService.getScheduleByAgent(
        agent?.userName,
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
      isDataLoading.value = false;
    }
  }

  Future<void> getAgentList() async {
    isDataLoading.value = true;
    try {
      final response = await _manageService.getAgentList();
      if (response.results != null && response.results!.isNotEmpty) {
        agentList.value = response.results!;
      } else {
        agentList.value = [];
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

  void submitForm(ScheduleDateTimeModel schedule, String approveMessage,bool accept) async {
    // Basic validation
    // if (remarksController.text.isEmpty) {
    //   AppToast.showToast(message: 'Please fill all fields.');
    //   return;
    // }
    AuthorizeRequest request = AuthorizeRequest(
      id: schedule.id,
      authorizedRemarks: approveMessage,
      isAuthorized: accept? "Cancel Accepted":"Cancel Rejected",
    );
    // print('Form Data: $request');
    try {
      isActionLoading.value = true;
      final response = await _manageService.updateAuthorizeSchedule(request);
      if (response.responseMessage?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to authorized.',
        );
      } else {
        AppToast.showToast(message: 'Schedule updated successfully!');
        getTodaysScheduleList();
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to authorize";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
    } catch (e) {
      AppToast.showToast();
    } finally {
      isActionLoading.value = false;
    }
    remarksController.clear();
  }
}
