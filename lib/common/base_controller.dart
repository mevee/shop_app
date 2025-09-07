import 'dart:async';

import 'package:get/get.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/utils/constants.dart';

class BaseController extends GetxController {
  final SessionPref userManager = SPrefSessiomImpl();
  Completer? clickJob;
  RxBool isClicked = false.obs;
  Future<void> click() {
    if (clickJob != null && !clickJob!.isCompleted) {
      return Future.value();
    }
    clickJob = Completer();
    isClicked.value = true;
    final job = Future.delayed(
      Duration(milliseconds: AppConstants.debounceTImeMiliSeconds),
      () {
        isClicked.value = false;
      },
    );
    clickJob?.complete(job);
    // return job!;
    return clickJob!.future;
  }
}
