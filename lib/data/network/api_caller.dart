import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app/exception/exceptions.dart';
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
    // Function(int statusCode, String message)? onServerError,
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
    } on DioException catch (e) {
      if (onComplete != null) onComplete();
      if (e.response != null) {
        // Server responded with an error status code
        final statusCode = e.response?.statusCode ?? 500;
        final errorMessage =
            _extractErrorMessage(e.response?.data) ??
            e.message ??
            'Server error occurred';
        Exception exception = ServerException(
          message: errorMessage,
          statusCode: statusCode,
        );
        if (onError != null) {
          onError(exception);
        }
      } else {
        if (onError != null) {
          onError(
            NetworkException(message: e.message ?? 'Network error occurred'),
          );
        }
      }
    } catch (error) {
      exceptionObj = Exception(error);
      if (onError != null) onError(exceptionObj);
      if (onComplete != null) onComplete();
    }
  }


  void showLoading() {
    DialogHelper.showLoading();
  }

  void hideLoading() {
    DialogHelper.hideLoading();
  }


  Future<void> callDataService2<T>(
  Future<T> future, {
  VoidCallback? onStart,
  VoidCallback? onComplete,
  ValueChanged<T>? onSuccess,
  ValueChanged<Exception>? onError,
  ValueChanged<String>? onNetworkError,
}) async {
  // Validate callbacks are provided when needed
  assert(
    onSuccess != null || onError != null || onNetworkError != null,
    'At least one of onSuccess, onError, or onNetworkError should be provided',
  );

  // Handle connectivity check
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    onNetworkError?.call(NetworkAPIServicesString.noInternetMessgae);
    onComplete?.call();
    return;
  }

  // Execute onStart callback
  onStart?.call();
  try {
    final T response = await future;
    onSuccess?.call(response);
  } on DioException catch (e) {
    final exception = _handleDioException(e);
    onError?.call(exception);
  } catch (error, stackTrace) {
    debugPrint('Unexpected error: $error\n$stackTrace');
    onError?.call(
      AppException(
        message: 'An unexpected error occurred',
        // originalError: error,
        // stackTrace: stackTrace,
      ),
    );
  } finally {
    onComplete?.call();
  }
}

Exception _handleDioException(DioException e) {
  if (e.response != null) {
    // Handle server response errors
    final statusCode = e.response?.statusCode ?? 500;
    final errorMessage = _extractErrorMessage(e.response?.data) ?? 
                        e.message ?? 
                        'Server error occurred';

    return ServerException(
      message: errorMessage,
      statusCode: statusCode,
      // responseData: e.response?.data,
    );
  } else {
    // Handle network/dio specific errors
    return NetworkException(
      message: e.message ?? 'Network error occurred',
      // dioError: e,
    );
  }
}

String? _extractErrorMessage(dynamic errorData) {
  if (errorData == null) return null;
  if (errorData is String) return errorData;
  if (errorData is Map<String, dynamic>) {
    return errorData['error'] ?? 
           errorData['message'] ?? 
           errorData['title'] ??
           errorData.toString();
  }
  return errorData.toString();
}
}
