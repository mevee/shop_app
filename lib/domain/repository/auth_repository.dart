import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/models/login_response.dart';

abstract interface class AuthRepository {
  Future<Either<Object, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  );
  Future<CommonEntity> forgotPasswordSendOtp(ForgotPasswordRequest request);
  Future<CommonEntity> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest request,
  );
  Future<CommonEntity> changePassword(ChangePasswordRequest request);
  Future<CommonEntity> logoutFromApp(LoginRequest request);
}
