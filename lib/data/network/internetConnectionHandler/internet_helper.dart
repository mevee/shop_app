// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';

// class ConnectivityService extends GetxService {
//   final Connectivity _connectivity = Connectivity();
//   final RxBool isConnected = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initConnectivity();
//     _setupConnectivityListener();
//   }

//   Future<void> _initConnectivity() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(connectivityResult);
//   }

//   void _setupConnectivityListener() {
//     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     isConnected.value = result != ConnectivityResult.none;
//   }

//   Future<bool> checkInternetConnection() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
// }