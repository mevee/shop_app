import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/modules/auth/controllers/auth_controller.dart';
import 'package:shop_app/modules/manager/controller/manager_controller.dart';

import '../../../data/schedule_service.dart';

class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerController>(() => ManagerController());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
  }
}
