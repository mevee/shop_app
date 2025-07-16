import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/employee_service.dart';
import 'package:shop_app/data/user_manager.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LoginServiceProtocol>(() => LoginService());
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<UserManager>(() => UserManager());
    Get.lazyPut<EmployeeServiceProtocol>(() => EmployeeService());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
