import 'package:fpdart/fpdart.dart';
import 'package:shop_app/domain/entity/response.dart';
import 'package:shop_app/domain/repository/auth_repository.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

class ResetPasswordUsecase {
  final AuthRepository authRepository;
  ResetPasswordUsecase(this.authRepository);

  Future<Either<Failure, CommonEntity>> call(ChangePasswordRequest request) {
    return authRepository.changePassword(request);
  }
}
