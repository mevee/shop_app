import 'package:get/get.dart';
import 'package:shop_app/data/manager_service.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<ManagerServiceProtocol>(() => ManagerService());
    Get.lazyPut<ShopMasterServiceProtocol>(() => ShopMasterService());
    Get.create<ScheduleServiceProtocol>(() => ScheduleService());
    Get.create<ScheduleController>(() => ScheduleController());
    Get.lazyPut<ShopMasterController>(() => ShopMasterController());
  }
}
