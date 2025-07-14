
import 'package:shop_app/data/network/network_interceptor.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_message$_prefix';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, NetworkAPIServicesString.communicationError);
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message, NetworkAPIServicesString.invalidRequest);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(message, NetworkAPIServicesString.unautorisedRequest);
}

class InvalidInputException extends AppException {
  InvalidInputException(String? message)
      : super(message, NetworkAPIServicesString.unauthouriseInput);
}
