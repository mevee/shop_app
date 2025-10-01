import 'package:get/get.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';
import 'package:shop_app/data/preference.dart';

class BaseController extends GetxController {
  final SessionPref userManager = SPrefSessiomImpl();
}
