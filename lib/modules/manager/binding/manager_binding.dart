import 'package:get/get.dart';
import 'package:shop_app/data/manager_service.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/modules/manager/controller/manager_controller.dart';

import '../../../data/schedule_service.dart';

class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerController>(() => ManagerController());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<ManagerServiceProtocol>(() => ManagerService());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
  }
}
