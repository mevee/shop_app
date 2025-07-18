import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/product_service.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/modules/schedule/controller/product_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<SessionPref>(() => SharePrefSessiomImpl());
    Get.lazyPut<ProductServiceProtocol>(() => ProductService());
    Get.lazyPut<ScheduleServiceProtocol>(() => ScheduleService());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
