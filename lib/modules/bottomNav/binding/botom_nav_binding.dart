import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/modules/bottomNav/controller/bottom_nav_controller.dart';
import 'package:shop_app/modules/calendar/controller/calender_controller.dart';
import 'package:shop_app/modules/home/controller/home_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<BotomNavController>(() => BotomNavController());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<EmployeeServiceProtocol>(() => EmployeeService());
    Get.lazyPut<LoginServiceProtocol>(() => LoginService());
    Get.lazyPut<ShopMasterServiceProtocol>(() => ShopMasterService());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<CallenderController>(() => CallenderController());
    Get.lazyPut<ShopMasterController>(() => ShopMasterController());
  }
}
