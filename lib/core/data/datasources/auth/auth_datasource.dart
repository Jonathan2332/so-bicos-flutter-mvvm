import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/external/models/auth/user_api_model.dart';

abstract class AuthDataSource {
  Future<Result<UserApiModel>> createUser(String email, String password);
  Future<Result<UserApiModel>> loginEmail(String email, String password);
  Future<Result<UserApiModel>> loginPhone(String phone);
  Future<Result<UserApiModel>> verifyPhoneCode(
    String verificationId,
    String code,
  );
  Future<Result<UserApiModel>> getLoggedUser();
  Future<void> logout();
}
