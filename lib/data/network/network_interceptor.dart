import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/widgets/dialog_helper.dart';
// import '../core/utils/logger.dart';

class NetworkAPIServicesString {
  static const noInternetMessgae = 'No Internet Connection';
  static const communicationError = 'Error During Communication';
  static const invalidRequest = 'Invalid request';
  static const unautorisedRequest = 'Unauthorised request';
  static const unauthouriseInput = 'Unauthorised Input';
}

class NetworkInterceptor extends InterceptorsWrapper {
  static bool isPopUpVisible = false;
  final SessionPref _userManager = getx.Get.find();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    if (options.headers.containsKey('Authorization')) {
      options.headers.remove('Authorization');
    }
    // if (options.headers.containsKey('x-role-type')) {
    //   options.headers.remove('x-role-type');
    // }
    options.contentType = 'application/json';
    String? token = _userManager.getUserToken();
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({'Authorization': token});
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // logf(tag: "NETWORK_INTERCEPTOR", message: err.toString());
    if (isTokenExpired(err)) {
      if (!isPopUpVisible) {
        isPopUpVisible = true;
        DialogHelper.showLogoutPopup(() async {
          // await logoutUser();
          isPopUpVisible = false;
        });
      }
    } else {
      handler.reject(err);
    }
  }

  bool isTokenExpired(DioException error) {
    return error.response?.data['status'] == 401;
  }

  Future<void> logoutUser() async {
    _userManager.logOut();
    Get.offAllNamed(Routes.login);
  }
}
