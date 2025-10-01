import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/domain/repository/auth_repository.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

class LoginUsecase {
  final AuthRepository authRepository;
  LoginUsecase(this.authRepository);

  Future<Either<Failure, APIResponse<LoginResponse>>> call(LoginRequest data) {
    return authRepository.getLoginResponse(data);
  }
}
