import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/data/network/net_util.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<Either<Failure, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  );
  Future<Either<Failure, CommonEntity>> forgotPasswordSendOtp(
    ForgotPasswordRequest request,
  );
  Future<Either<Failure, CommonEntity>> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest request,
  );
  Future<Either<Failure, CommonEntity>> changePassword(
    ChangePasswordRequest request,
  );
  Future<Either<Failure, CommonEntity>> logoutFromApp(LoginRequest request);
}

class AuthRemoteDataSourceImpl extends BaseNetworkClient
    implements AuthRemoteDataSource {
   @override
  Future<Either<Failure, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  ) async {
    if (!await NetUtil.isNetworkAvailable()) {
      return left(NetworkException(message: "No internet connection"));
    }
    const endPoint = EndPoints.login;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      final loginData = response.data;
      aLog(loginData);
      return Either.right(
        APIResponse(
          response: LoginResponse.fromJson(response.data),
          statusCode: response.statusCode ?? 400,
          accessToken: response.toString(),
          userId: response.toString(),
        ),
      );
    } on DioException catch (e) {
      return left(handleExp(e));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, CommonEntity>> forgotPasswordSendOtp(
    ForgotPasswordRequest data,
  ) async {
    const endPoint = EndPoints.forgotPasswordAndSendOtp;
    if (!await NetUtil.isNetworkAvailable()) {
      return Left(NetworkException(message: "No internet connection"));
    }
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return Right(CommonEntity.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleExp(e));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, CommonEntity>> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest data,
  ) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return Right(CommonEntity.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleExp(e));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, CommonEntity>> changePassword(
    ChangePasswordRequest data,
  ) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return Right(CommonEntity.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleExp(e));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, CommonEntity>> logoutFromApp(
    LoginRequest request,
  ) async {
    var endPoint = EndPoints.userLogoutPOST;

    try {
      final response = await client.post(endPoint, data: request.toJson());
      return Right(CommonEntity.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleExp(e));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }
}
