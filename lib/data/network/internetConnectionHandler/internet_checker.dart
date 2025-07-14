import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class INetworkInfoProvider {
  RxBool get isNetworkConnected;
  Future<bool> hasNetworkConnected();
}

class NetworkController extends GetConnect implements INetworkInfoProvider {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  bool connectionPresent = true;

  @override
  RxBool get isNetworkConnected {
    return connectionPresent.obs;
  }

  @override
  void onInit() async {
    super.onInit();
    await initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((event) async {
      _updateConnectionStatus(await _connectivity.checkConnectivity());
    });
  }

  @override
  void onClose() {
    super.onClose();
    _subscription.cancel();
  }

  /// Check init connection
  Future<void> initConnectivity() async {
    try {
      _updateConnectionStatus(await _connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PlatformException Error${e.stacktrace}');
      }
    }
  }

  /// Network changes Listen
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      isNetworkConnected.value = true;
      connectionPresent = true;
    } else {
      isNetworkConnected.value = false;
      connectionPresent = false;
    }
  }

  /// Check network is connected
  /// If network is connected then return bool status
  /// otherwise show snack-bar
  ///
  @override
  Future<bool> hasNetworkConnected() async {
    await _updateConnectionStatus(await _connectivity.checkConnectivity());
    if (!isNetworkConnected.value) {
      return false;
    }
    return isNetworkConnected.value;
  }
}
