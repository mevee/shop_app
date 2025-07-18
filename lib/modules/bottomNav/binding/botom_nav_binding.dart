import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/modules/bottomNav/controller/bottom_nav_controller.dart';
import 'package:shop_app/modules/calendar/controller/calender_controller.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<BotomNavController>(() => BotomNavController());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<EmployeeServiceProtocol>(() => EmployeeService());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<CallenderController>(() => CallenderController());
  }
}
