import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/location_service/tracking_service.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState(), fenix: true);
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl(), fenix: true);
    Get.lazyPut<ShopMasterServiceProtocol>(() => ShopMasterService());
    Get.lazyPut<LocationSyncService>(() => LocationSyncService());

  }
}
