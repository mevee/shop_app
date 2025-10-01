import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

abstract interface class AuthRepository {
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
  Future<Either<Failure, CommonEntity>> logoutFromApp(
    LoginRequest request,
  );
}
