import 'package:get/get_connect/http/src/status/http_status.dart';

class APIResponse<T> {
  int statusCode;
  HttpStatus? status;
  bool? unauthorized;
  String accessToken;
  String userId;
  T response;

  APIResponse(
      {required this.statusCode,
      this.status,
      this.unauthorized,
      required this.accessToken,
      required this.userId,
      required this.response});
}
