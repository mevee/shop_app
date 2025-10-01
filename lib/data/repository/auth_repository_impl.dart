import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/data/data_source/drs_auth_remote.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/domain/repository/auth_repository.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

class AuthRepoImpl implements AuthRepository {
  AuthRemoteDataSource dataSource;
  AuthRepoImpl(this.dataSource);

  @override
  Future<Either<Failure, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  ) async {
    return await dataSource.getLoginResponse(data);
  }

  @override
  Future<Either<Failure, CommonEntity>> forgotPasswordSendOtp(
    ForgotPasswordRequest data,
  ) async {
    return await dataSource.forgotPasswordSendOtp(data);
  }

  @override
  Future<Either<Failure, CommonEntity>> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest data,
  ) async {
    return await dataSource.verifyOtpAndChangePassword(data);
  }

  @override
  Future<Either<Failure, CommonEntity>> changePassword(
    ChangePasswordRequest data,
  ) async {
    return await dataSource.changePassword(data);
  }

  @override
  Future<Either<Failure, CommonEntity>> logoutFromApp(
    LoginRequest request,
  ) async {
    return await dataSource.logoutFromApp(request);
  }
}
