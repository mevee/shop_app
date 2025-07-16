class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => 'AppException: $message';
}