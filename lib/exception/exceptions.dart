import 'package:dio/dio.dart';

// class Failure implements Exception {}
class Failure implements Exception {
  final String message;
  Failure({required this.message});
  @override
  String toString() => 'AppException: $message';
}

class ServerException implements Failure {
  @override
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}

class NetworkException implements Failure {
  @override
  final String message;
  NetworkException({required this.message});
}

Failure handleExp(DioException e) {
  if (e.response != null) {
    // Server responded with an error status code (like 500)
    print('Error status code: ${e.response?.statusCode}');
    print('Error response data: ${e.response?.data}');
    // You can throw a custom exception or return an error response
    return ServerException(
      message: e.response?.data['error'] ?? 'Internal Server Error',
      statusCode: e.response?.statusCode ?? 500,
    );
  } else {
    // Other Dio errors (network, timeout, etc.)
    return NetworkException(message: e.message ?? 'Network error occurred');
  }
}
