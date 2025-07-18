import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/data/datasources/auth/auth_datasource.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository.dart';
import 'package:so_bicos/core/domain/models/auth/user.dart';
import 'package:so_bicos/core/external/models/auth/user_api_model.dart';

extension EntityParse on Future<Result<UserApiModel>> {
  Future<Result<User>> mapToEntity() => mapFold(_toEntity, (error) => error);
}

User _toEntity(UserApiModel model) {
  return User(
    name: model.name ?? "Unknown",
    email: model.email ?? "Unknown",
    phoneNumber: model.phoneNumber ?? "Unknown",
  );
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Result<User>> getLoggedUser() =>
      dataSource.getLoggedUser().mapToEntity();

  @override
  Future<Result<User>> createUser(String email, String password) async {
    final result = await dataSource.createUser(email, password).mapToEntity();
    notifyListeners();
    return result;
  }

  @override
  Future<Result<User>> loginEmail(String email, String password) async {
    final result = await dataSource.loginEmail(email, password).mapToEntity();
    notifyListeners();
    return result;
  }

  @override
  Future<Result<User>> loginPhone(String phone) async {
    final result = await dataSource.loginPhone(phone).mapToEntity();
    notifyListeners();
    return result;
  }

  @override
  Future<void> logout() async {
    final result = await dataSource.logout();
    notifyListeners();
    return result;
  }

  @override
  Future<Result<User>> verifyPhoneCode(
    String verificationId,
    String code,
  ) async {
    final result = await dataSource
        .verifyPhoneCode(verificationId, code)
        .mapToEntity();
    notifyListeners();
    return result;
  }
}
