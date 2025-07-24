import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class ShopMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
    Get.lazyPut<ShopMasterServiceProtocol>(() => ShopMasterService());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<ShopMasterController>(() => ShopMasterController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
