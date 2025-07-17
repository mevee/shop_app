import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/user_manager.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/schedule_list_response.dart';

class CallenderController extends BaseController {
  final UserManager _userManager = Get.find();
  final ScheduleServiceProtocol _scheduleService = Get.find();
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  RxBool isLoding = false.obs;
  DateTime focusedMonth = DateTime.now();
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
  // In a real application, this data would come from an API or database
  RxMap<DateTime, List<String>> dailyData = <DateTime, List<String>>{}.obs;
    // Example data for June 2025 (matching the image roughly)
  //   DateTime(2025, 6, 19): [
  //     '85 A ...',
  //     'War ...',
  //     'Gha ...',
  //     'Kha ...',
  //   ], // Red day in image
  //   DateTime(2025, 6, 20): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
  //   DateTime(2025, 6, 21): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
  //   DateTime(2025, 6, 22): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
  //   DateTime(2025, 6, 23): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
  //   DateTime(2025, 6, 24): [
  //     '165 ...',
  //     'Bho ...',
  //     'Govi ...',
  //     'Gul ...',
  //   ], // Red day in image
  //   DateTime(2025, 6, 25): ['Bhar ...', 'Ghu ...', 'Pan ...', 'Plot ...'],
  //   DateTime(2025, 6, 26): ['85 A ...', 'War ...', 'Gha ...', 'Kha ...'],
  //   DateTime(2025, 6, 27): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
  //   DateTime(2025, 6, 28): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
  //   DateTime(2025, 6, 29): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
  // };

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
      focusedMonth.year,
      focusedMonth.month,
      1,
    );

    // Get the last day of the focused month
    final DateTime lastDayOfMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
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
      daysInGrid.add(DateTime(focusedMonth.year, focusedMonth.month, i));
    }

    // Add days from the next month to fill the last week
    while (daysInGrid.length % 7 != 0) {
      daysInGrid.add(daysInGrid.last.add(const Duration(days: 1)));
    }
  }

  // Helper function to navigate to the previous month
  void goToPreviousMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1, 1);
  }

  // Helper function to navigate to the next month
  void goToNextMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 1);
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
    for (var item in list) {
      final date = DateTime.parse(item.scheduleDateTime!);
      if (dailyData.containsKey(date)) {
        // item.dailyData = dailyData[date]!;
      } else {
        // item.dailyData = [];
      }
    }

  }

  // void getOutLocation() {
  //   isPunchOutProgress.value = true;
  //   refreshLocation().then((_) {
  //     if (currentPosition != null) {
  //       inLocation = LocationLatLon(
  //         lat: currentPosition!.latitude,
  //         long: currentPosition!.longitude,
  //       );
  //       _clockOut();
  //     } else {
  //       AppToast.showToast(message: 'Failed to get in location');
  //     }
  //     isPunchOutProgress.value = false;
  //   });
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
}
