import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/domain/models/auth/errors.dart';
import 'package:so_bicos/core/external/datasources/auth/firebase_datasource_impl.dart';
import 'package:so_bicos/core/external/models/auth/user_api_model.dart';

import '../../../../fakes/core/external/models/user_api_model_fake.dart';
@GenerateNiceMocks([
  MockSpec<User>(as: #UserMock),
  MockSpec<UserCredential>(as: #UserCredentialMock),
  MockSpec<PhoneAuthCredential>(as: #PhoneAuthCredentialMock),
  MockSpec<FirebaseAuthException>(as: #FirebaseAuthExceptionMock),
])
import 'firebase_datasource_impl_test.mocks.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return userCredential;
  }

  @override
  Future<void> signOut() {
    return Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return userCredential;
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return userCredential;
  }

  @override
  Future<void> verifyPhoneNumber({
    String? phoneNumber,
    PhoneMultiFactorInfo? multiFactorInfo,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
    MultiFactorSession? multiFactorSession,
  }) async {
    Invocation.method(#verifyPhoneNumber, [
      phoneNumber,
      autoRetrievedSmsCodeForTesting,
      forceResendingToken,
      multiFactorSession,
    ]);
    Future.delayed(Duration(microseconds: 800)).then((value) {
      switch (phoneNumber) {
        case "1234567":
          verificationCompleted(phoneAuthCredential);
        case "1":
          verificationFailed(authException);
        case "2":
          codeSent("jfk562", 1);
        default:
          {
            codeAutoRetrievalTimeout("jfk562");
            codeSent("jfk562", 1);
          }
      }
    });
  }
}

@GenerateMocks([FirebaseAuthMock])
final phoneAuthCredential = PhoneAuthCredentialMock();
final userCredential = UserCredentialMock();
final authException = FirebaseAuthExceptionMock();

void main() {
  final nameTest = "Jonathan";
  final emailTest = "jonathan@gmail.com";
  final passwordTest = "12345";
  final phoneNumberTest = "1234567";

  final userApiModel = UserApiModel(
    name: nameTest,
    email: emailTest,
    phoneNumber: phoneNumberTest,
  );

  final auth = FirebaseAuthMock();
  final firebaseUser = UserMock();

  final dataSource = FirebaseDataSourceImpl(auth: auth);

  setUpAll(() {
    when(firebaseUser.displayName).thenReturn(nameTest);
    when(firebaseUser.email).thenReturn(emailTest);
    when(firebaseUser.phoneNumber).thenReturn(phoneNumberTest);
    when(userCredential.user).thenReturn(firebaseUser);
  });

  test(
    'should get success when create new user with email and password',
    () async {
      final result = await dataSource.createUser(emailTest, passwordTest);
      expect(result, isA<Result<UserApiModel>>());
      expect(result.getOrNull()?.email, equals(userApiModelFake.email));
    },
  );

  test('should get success when login with email and password', () async {
    final result = await dataSource.loginEmail(emailTest, passwordTest);
    expect(result, isA<Result<UserApiModel>>());
    expect(result.getOrNull()?.email, equals(userApiModelFake.email));
  });

  test('should get success when validate the code', () async {
    final result = await dataSource.verifyPhoneCode(phoneNumberTest, "123");
    expect(result, isA<Result<UserApiModel>>());
    expect(result.getOrNull()?.phoneNumber, equals(userApiModel.phoneNumber));
  });

  group('loginPhone', () {
    test('should get success when login with phone', () async {
      final result = await dataSource.loginPhone(phoneNumberTest);
      expect(result, isA<Result<UserApiModel>>());
      expect(result.getOrNull()?.phoneNumber, equals(userApiModel.phoneNumber));
    });

    test('should get error when login with phone', () async {
      expect(
        () async => await dataSource.loginPhone("1"),
        throwsA(authException),
      );
    });

    test('should get LoginPhoneException when login with phone', () async {
      expect(
        () async => await dataSource.loginPhone("3"),
        throwsA(isA<LoginPhoneException>()),
      );
    });
  });

  group("logged user", () {
    test('should get logged user with successfull', () async {
      when(auth.currentUser).thenAnswer((_) => firebaseUser);
      final result = await dataSource.getLoggedUser();
      expect(result, isA<Result<UserApiModel>>());
      expect(result.getOrNull()?.email, equals(userApiModelFake.email));
    });

    test('should get LoggedUserException when get user', () async {
      when(auth.currentUser).thenAnswer((_) => null);
      final result = await dataSource.getLoggedUser();
      expect(result, isA<Result<UserApiModel>>());
      expect(result.exceptionOrNull(), isA<LoggedUserException>());
      expect(result.isError(), true);
    });
  });

  group("logout", () {
    test('should get logout with success', () async {
      expect(dataSource.logout(), completes);
    });
  });
}
