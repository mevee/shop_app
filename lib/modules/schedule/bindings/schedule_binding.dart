import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/user_manager.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<UserManager>(() => UserManager());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
