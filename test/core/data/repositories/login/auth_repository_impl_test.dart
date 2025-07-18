import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/data/datasources/auth/auth_datasource.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository_impl.dart';
import 'package:so_bicos/core/domain/models/auth/errors.dart';
import 'package:so_bicos/core/domain/models/auth/user.dart';
import 'package:so_bicos/core/external/models/auth/user_api_model.dart';

import '../../../../fakes/core/external/models/user_api_model_fake.dart';

@GenerateNiceMocks([MockSpec<AuthDataSource>(as: #AuthDataSourceMock)])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late final AuthDataSourceMock dataSource;
  late final AuthRepositoryImpl repository;

  final nameTest = "Jonathan";
  final emailTest = "jonathan@gmail.com";
  final passwordTest = "123";
  final phoneNumberTest = "1234567";

  final userApiModel = UserApiModel(
    name: nameTest,
    email: emailTest,
    phoneNumber: phoneNumberTest,
  );

  setUpAll(() {
    dataSource = AuthDataSourceMock();
    repository = AuthRepositoryImpl(dataSource: dataSource);
  });

  group("signup", () {
    test('should create user with success', () async {
      final Result<UserApiModel> dummy = Success(userApiModel);
      provideDummy(dummy);

      when(
        dataSource.createUser(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.createUser(emailTest, passwordTest);
      expect(result, isA<Result<User>>());
      expect(result.getOrNull()?.email, userApiModelFake.email);
    });

    test('should get CreateUserException', () async {
      final Result<UserApiModel> dummy = Failure(
        CreateUserException(message: "error on create new user"),
      );
      provideDummy(dummy);

      when(
        dataSource.createUser(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.createUser(emailTest, passwordTest);
      expect(result, isA<Result<User>>());
      expect(result.exceptionOrNull(), isA<CreateUserException>());
      expect(result.isError(), true);
    });
  });

  group("login with email", () {
    test('should login with success', () async {
      final Result<UserApiModel> dummy = Success(userApiModel);
      provideDummy(dummy);

      when(
        dataSource.loginEmail(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.loginEmail(emailTest, passwordTest);
      expect(result, isA<Result<User>>());
      expect(result.getOrNull()?.email, userApiModelFake.email);
    });

    test('should get LoginEmailException', () async {
      final Result<UserApiModel> dummy = Failure(
        LoginEmailException(message: "error on login with email"),
      );
      provideDummy(dummy);

      when(
        dataSource.loginEmail(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.loginEmail(emailTest, passwordTest);
      expect(result, isA<Result<User>>());
      expect(result.exceptionOrNull(), isA<LoginEmailException>());
      expect(result.isError(), true);
    });
  });

  group("login with phone", () {
    test('should login with success', () async {
      final Result<UserApiModel> dummy = Success(userApiModel);
      provideDummy(dummy);

      when(
        dataSource.loginPhone(phoneNumberTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.loginPhone(phoneNumberTest);
      expect(result, isA<Result<User>>());
      expect(result.getOrNull()?.phoneNumber, userApiModelFake.phoneNumber);
    });

    test('should get LoginPhoneException', () async {
      final Result<UserApiModel> dummy = Failure(
        LoginPhoneException(message: "error on login with email"),
      );
      provideDummy(dummy);

      when(
        dataSource.loginPhone(phoneNumberTest),
      ).thenAnswer((_) async => dummy);
      final result = await repository.loginPhone(phoneNumberTest);
      expect(result, isA<Result<User>>());
      expect(result.exceptionOrNull(), isA<LoginPhoneException>());
      expect(result.isError(), true);
    });
  });

  group("verify phone code", () {
    test('should login with success with verify code', () async {
      final Result<UserApiModel> dummy = Success(userApiModel);
      provideDummy(dummy);

      when(dataSource.verifyPhoneCode(any, any)).thenAnswer((_) async => dummy);
      final result = await repository.verifyPhoneCode('123', '123456');
      expect(result, isA<Result<User>>());
      expect(result.getOrNull()?.phoneNumber, userApiModelFake.phoneNumber);
    });

    test('should get LoginVerifyException', () async {
      final Result<UserApiModel> dummy = Failure(
        LoginVerifyException(message: "error on login with verification code"),
      );
      provideDummy(dummy);

      when(dataSource.verifyPhoneCode(any, any)).thenAnswer((_) async => dummy);
      final result = await repository.verifyPhoneCode('123', '123456');
      expect(result, isA<Result<User>>());
      expect(result.exceptionOrNull(), isA<LoginVerifyException>());
      expect(result.isError(), true);
    });
  });

  group("get logged user", () {
    test('should get current logged user', () async {
      final Result<UserApiModel> dummy = Success(userApiModel);
      provideDummy(dummy);

      when(dataSource.getLoggedUser()).thenAnswer((_) async => dummy);
      final result = await repository.getLoggedUser();
      expect(result, isA<Result<User>>());
      expect(result.getOrNull()?.name, userApiModelFake.name);
    });

    test('should get LoggedUserException', () async {
      final Result<UserApiModel> dummy = Failure(
        LoggedUserException(message: "error on get logged user"),
      );
      provideDummy(dummy);

      when(dataSource.getLoggedUser()).thenAnswer((_) async => dummy);
      final result = await repository.getLoggedUser();
      expect(result, isA<Result<User>>());
      expect(result.exceptionOrNull(), isA<LoggedUserException>());
      expect(result.isError(), true);
    });
  });

  group("logout", () {
    test('should get logout', () async {
      final Result<void> dummy = Success(unit);
      provideDummy(dummy);

      when(dataSource.logout()).thenAnswer((_) async => dummy);
      expect(repository.logout(), completes);
    });

    test('should Throw when user try logout', () async {
      final Result<void> dummy = Failure(
        LogoutException(message: 'Error on logout'),
      );
      provideDummy(dummy);

      when(dataSource.logout()).thenAnswer((_) async => dummy);
      expect(repository.logout(), completes);
    });
  });
}
