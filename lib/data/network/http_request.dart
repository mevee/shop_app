import 'dart:io';
import 'package:get/get.dart';
import 'package:shop_app/data/network/app_exception.dart';

import 'network_interceptor.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(
      {required String url,
      Map<String, String>? headers,
      Map<String, dynamic>? query});

  Future<dynamic> getPostApiResponse(
      {required String url, dynamic data, Map<String, String>? headers});

  Future<dynamic> getPatchApiResponse(
      {String? url, Map<String, String>? headers, dynamic body});

  Future<dynamic> getDeleteApiResponse(
      {required String url, Map<String, String>? headers, dynamic body});

  Future<dynamic> postImages(
      {required String url, Map<String, String>? headers, dynamic body});

  Future<dynamic> deleteProfilePic(
      {required String url, Map<String, String>? headers, dynamic body});

  Future<dynamic> putApiResponse(
      {required String url, Map<String, String>? headers, dynamic body});
}

class NetworkAPIServices extends GetConnect implements BaseApiServices {
  dynamic responseJSON;

  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(minutes: 20);
  }

  @override
  Future deleteProfilePic(
      {required String url, Map<String, String>? headers, body}) async {
    try {
      responseJSON = await delete(url, headers: headers)
          .timeout(const Duration(minutes: 1));
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }

  @override
  Future getDeleteApiResponse(
      {required String url, Map<String, String>? headers, body}) async {
    try {
      final response = await delete(url, headers: headers);
      responseJSON = response;
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }

  @override
  Future getGetApiResponse(
      {required String url,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    try {
      responseJSON = await get(url, headers: headers, query: query);
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }

  @override
  Future getPatchApiResponse(
      {String? url,
      Map<String, String>? headers,
      body,
      Map<String, dynamic>? query}) async {
    try {
      responseJSON =
          await patch(url ?? "", body, headers: headers, query: query);
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
  }

  @override
  Future getPostApiResponse(
      {required String url, dynamic data, Map<String, String>? headers}) async {
    try {
      // ignore: unrelated_type_equality_checks
      if (headers == Null) {
        headers = {"Content-Type": "application/json"};
      }
      responseJSON = await post(url, data,
          contentType: "application/json", headers: headers);
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }

  @override
  Future postImages(
      {required String url,
      Map<String, String>? headers,
      body,
      Map<String, dynamic>? query}) async {
    try {
      responseJSON = await post(url, body,
              contentType: 'multipart/form-data',
              headers: headers,
              query: query)
          .timeout(const Duration(minutes: 15));
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }

  @override
  Future putApiResponse(
      {required String url,
      Map<String, String>? headers,
      body,
      Map<String, dynamic>? query}) async {
    headers ??= {"Content-Type": "application/json"};

    try {
      responseJSON = await put(url, body, headers: headers, query: query);
    } on SocketException {
      throw FetchDataException(NetworkAPIServicesString.noInternetMessgae);
    }
    return responseJSON;
  }
}
