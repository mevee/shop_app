import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/modules/home/controller/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LoginServiceProtocol>(() => LoginService());
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<EmployeeServiceProtocol>(() => EmployeeService());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
