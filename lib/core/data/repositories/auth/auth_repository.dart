import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/domain/models/auth/user.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<Result<User>> createUser(String email, String password);
  Future<Result<User>> loginEmail(String email, String password);
  Future<Result<User>> loginPhone(String phone);
  Future<Result<User>> verifyPhoneCode(String verificationId, String code);
  Future<Result<User>> getLoggedUser();
  Future<void> logout();
}