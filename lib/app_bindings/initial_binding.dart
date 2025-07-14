import 'package:get/get.dart';
import 'package:shop_app/data/user_manager.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManager>(() => UserManager(), fenix: true);
  }
}
