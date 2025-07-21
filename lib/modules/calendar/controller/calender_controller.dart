import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/schedule_list_response.dart';

class CallenderController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ScheduleServiceProtocol _scheduleService = Get.find();
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  RxBool isLoding = false.obs;
  Rx<DateTime> focusedMonth = DateTime.now().obs;
  // Create a list of all days to display in the grid (including prev/next month's overflow)
  RxList<DateTime> daysInGrid = <DateTime>[].obs;

  // Days of the week header
  final List<String> weekdays = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  RxMap<DateTime, List<ScheduleDateTimeModel>> dailyData =
      <DateTime, List<ScheduleDateTimeModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // loadUserData();
    prepareCellForDisplay();
    getTodaysScheduleList(DateFormatter.currentDate);
  }

  void prepareCellForDisplay() {
    // Get the first day of the focused month
    final DateTime firstDayOfMonth = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month,
      1,
    );

    // Get the last day of the focused month
    final DateTime lastDayOfMonth = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + 1,
      0,
    );

    // Determine the weekday of the first day (Sunday=7, Monday=1, ..., Saturday=6)
    final int firstWeekday = firstDayOfMonth.weekday == 7
        ? 0
        : firstDayOfMonth.weekday; // Adjust so Sunday is 0

    // Add days from the previous month to fill the first week
    for (int i = firstWeekday; i > 0; i--) {
      daysInGrid.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Add all days of the current month
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      daysInGrid.add(
        DateTime(focusedMonth.value.year, focusedMonth.value.month, i),
      );
    }

    // Add days from the next month to fill the last week
    while (daysInGrid.length % 7 != 0) {
      daysInGrid.add(daysInGrid.last.add(const Duration(days: 1)));
    }
  }

  // Helper function to navigate to the previous month
  void goToPreviousMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month - 1,
      1,
    );
    refreshUiElemnst();
  }

  void refreshUiElemnst() {
    focusedMonth.refresh();
    daysInGrid.refresh();
  }

  // Helper function to navigate to the next month
  void goToNextMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + 1,
      1,
    );
    refreshUiElemnst();
  }

  Future<void> getTodaysScheduleList(String? date) async {
    isLoding.value = true;
    try {
      final response = await _scheduleService.getScheduleByMonth(date);
      if (response.results != null && response.results!.isNotEmpty) {
        scheduleList.value = response.results!;
        setUiData(response.results!);
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

  void setUiData(List<ScheduleDateTimeModel> list) {
    dailyData.clear();
    for (var apiModel in list) {
      final date = DateTime.parse(apiModel.day!);
      if (dailyData.containsKey(date)) {
        final keyList = dailyData[date];
        if (keyList != null) {
          keyList.add(apiModel);
        }
      } else {
        dailyData[date] = [apiModel];
      }
    }
    print("DATA:$dailyData");
    refreshUiElemnst();
  }

  List<ScheduleDateTimeModel> checkIfSchedulAvailable(DateTime date) {
    bool isAvailable = false;
    if (dailyData.containsKey(date) &&
        dailyData[date] != null &&
        dailyData[date]!.isNotEmpty) {
      isAvailable = true;
    } else {
      isAvailable = false;
    }
    if (isAvailable) {
      return dailyData[date]!;
    } else {
      return <ScheduleDateTimeModel>[];
    }
  }
}
