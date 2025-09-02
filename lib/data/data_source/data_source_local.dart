import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/domain/repository/auth_repository.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

class LocalDataSource extends BaseNetworkClient implements AuthRepository {
  @override
  Future<Either<Object, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  ) async {
    const endPoint = EndPoints.login;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      final loginData = response.data;
      print(loginData);
      return Either.right(
        APIResponse(
          response: LoginResponse.fromJson(response.data),
          statusCode: response.statusCode ?? 400,
          accessToken: response.toString(),
          userId: response.toString(),
          // accessToken: response.headers['x-access-token']?.first ?? "",
          // userId: response.headers['x-userId']?.first ?? "",
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CommonEntity> forgotPasswordSendOtp(ForgotPasswordRequest data) async {
    const endPoint = EndPoints.forgotPasswordAndSendOtp;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return CommonEntity.fromJson(response.data,);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server responded with an error status code (like 500)
        print('Error status code: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');

        // You can throw a custom exception or return an error response
        throw ServerException(
          message: e.response?.data['error'] ?? 'Internal Server Error',
          statusCode: e.response?.statusCode ?? 500,
        );
      } else {
        // Other Dio errors (network, timeout, etc.)
        throw NetworkException(message: e.message ?? 'Network error occurred');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CommonEntity> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest data,
  ) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return CommonEntity.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CommonEntity> changePassword(ChangePasswordRequest data) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return CommonEntity.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CommonEntity> logoutFromApp(LoginRequest request) async {
    var endPoint = EndPoints.userLogoutPOST;

    try {
      final response = await client.post(endPoint, data: request.toJson());
      return CommonEntity.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // You can throw a custom exception or return an error response
        throw ServerException(
          message: e.response?.data['error'] ?? 'Internal Server Error',
          statusCode: e.response?.statusCode ?? 500,
        );
      } else {
        // Other Dio errors (network, timeout, etc.)
        throw NetworkException(message: e.message ?? 'Network error occurred');
      }
    } catch (error) {
      rethrow;
    }
  }
}
