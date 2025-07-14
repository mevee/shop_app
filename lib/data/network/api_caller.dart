import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app/widgets/dialog_helper.dart';

import 'network_interceptor.dart';

extension BaseController on GetxController {
  Future<void> callDataService<T>(
    Future future, {
    Function? onStart,
    Function? onComplete,
    Function(T response)? onSuccess,
    Function(Exception exception)? onError,
    Function(String message)? onNetworkError,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (onNetworkError != null) {
        onNetworkError(NetworkAPIServicesString.noInternetMessgae);
      }
      if (onComplete != null) onComplete();
      return;
    }

    Exception? exceptionObj;
    if (onStart != null) onStart();
    try {
      final T response = await future;
      if (onComplete != null) onComplete();
      if (onSuccess != null) onSuccess(response);
      return;
    } catch (error) {
      exceptionObj = Exception(error);
    }
    if (onError != null) onError(exceptionObj);
    if (onComplete != null) onComplete();
  }

  void showLoading() {
    DialogHelper.showLoading();
  }

  void hideLoading() {
    DialogHelper.hideLoading();
  }
}
