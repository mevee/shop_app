class InvalidCredentialException implements Exception {
  InvalidCredentialException(this.message);
  final String message;
}

class NotFoundException implements Exception {
  NotFoundException(this.message);
  final String message;
}

class UnauthorizedException implements Exception {
  UnauthorizedException(this.message);
  final String message;
}

class UnknownException implements Exception {
  UnknownException(this.message);
  final String message;
}

class TokenException implements Exception {
  TokenException(this.message);
  final String message;
}

class UserException implements Exception {
  UserException(this.message);
  final String message;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
}

class InternetException implements Exception {
  InternetException(this.message);
  final String message;
}
