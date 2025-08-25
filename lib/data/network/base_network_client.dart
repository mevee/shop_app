import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shop_app/utils/constants.dart';

import 'network_interceptor.dart';

abstract class BaseNetworkClient {
  final _connectionTimout = 20;
  final _receiveTimout = 20;
  final maxLogWidth = 90;
  final _baseUrl = AppConstants.baseUrl;
  late final Dio client;

  BaseNetworkClient() {
    // * Initilize Dio on construct
    client = Dio(BaseOptions(
      connectTimeout: Duration(minutes: _connectionTimout),
      receiveTimeout: Duration(minutes: _receiveTimout),
      baseUrl: _baseUrl,
    ));

    // * Configure Interceptor
    client.interceptors.add(NetworkInterceptor());

    // * Add Logger to Print Network Activity on DebugMode
    if (kDebugMode) {
      client.interceptors.add(
        PrettyDioLogger(
          maxWidth: maxLogWidth,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
    }
  }
}
