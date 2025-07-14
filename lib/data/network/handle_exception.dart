import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/network/network_interceptor.dart';
import 'internetConnectionHandler/internet_checker.dart';
import 'network_exception.dart';

void handleNetworkException(DioException error) {
  final INetworkInfoProvider networkInfoProvider = Get.find();
  if (!networkInfoProvider.isNetworkConnected.value) {
    throw InternetException(NetworkAPIServicesString.noInternetMessgae);
  }
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      throw InternetException(
        NetworkAPIServicesString.noInternetMessgae,
      );
    case DioExceptionType.connectionError:
      throw InternetException(
        NetworkAPIServicesString.noInternetMessgae,
      );
    default:
      switch (error.response?.data['status']) {
        // case ErrorCode.authInvalidAccessToken:
        //   throw AuthException(error.response?.data['message'] ??
        //       error.message ??
        //       error.toString());
        // case ErrorCode.authUserNotFound:
        //   throw AuthException(error.response?.data['message'] ??
        //       error.message ??
        //       error.toString());
        // case ErrorCode.authBadRequest:
        // throw ApiException(NetworkAPIServicesString.unkownError);
        //   // throw ApiException(error.response?.data['message'] ??
        //   //     error.message ??
        //   //     error.toString());
        // case ErrorCode.serverError:
        //   throw ApiException(NetworkAPIServicesString.unkownError);
        // throw ApiException(error.response?.data['message'] ??
        //     error.message ??
        //     error.toString());
        default:
          throw UnknownException('Something Went Wrong');
      }
  }
}
