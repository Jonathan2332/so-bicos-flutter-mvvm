// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import 'package:so_bicos/core/data/datasources/auth/auth_datasource.dart';
import 'package:so_bicos/core/domain/models/auth/errors.dart';
import 'package:so_bicos/core/external/models/auth/user_api_model.dart';

class FirebaseDataSourceImpl implements AuthDataSource {
  final FirebaseAuth auth;

  FirebaseDataSourceImpl({required this.auth});

  @override
  Future<Result<UserApiModel>> getLoggedUser() async {
    final user = auth.currentUser;
    if (user == null) {
      return Failure(
        LoggedUserException(message: "Error on get logged user, user null"),
      );
    }

    return Success(
      UserApiModel(
        name: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
      ),
    );
  }

  @override
  Future<Result<UserApiModel>> createUser(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return Failure(
          LoginEmailException(message: "Error on create user, user null"),
        );
      }

      return Success(
        UserApiModel(
          name: user.displayName,
          email: user.email,
          phoneNumber: user.phoneNumber,
        ),
      );
    } on FirebaseAuthException catch (f) {
      return Failure(f);
    }
  }

  @override
  Future<Result<UserApiModel>> loginEmail(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return Failure(
          LoginEmailException(message: "Error on login with email, user null"),
        );
      }

      return Success(
        UserApiModel(
          name: user.displayName,
          email: user.email,
          phoneNumber: user.phoneNumber,
        ),
      );
    } on FirebaseAuthException catch (f) {
      return Failure(f);
    }
  }

  @override
  Future<Result<UserApiModel>> loginPhone(String phone) async {
    final completer = Completer<AuthCredential>();
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 30),
      verificationCompleted: completer.complete,
      verificationFailed: completer.completeError,
      codeSent: (String verificationId, int? forceResendingToken) {
        completer.completeError(
          LoginPhoneException(
            message: "Error on verification: $verificationId",
          ),
        );
      },
      codeAutoRetrievalTimeout: (v) {},
    );

    final credential = await completer.future;
    final user = (await auth.signInWithCredential(credential)).user;

    if (user == null) {
      return Failure(
        LoginPhoneException(message: "Error on login with phone, user null"),
      );
    }

    return Success(
      UserApiModel(
        name: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
      ),
    );
  }

  @override
  Future<Result<UserApiModel>> verifyPhoneCode(
    String verificationId,
    String code,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    final user = (await auth.signInWithCredential(credential)).user;

    if (user == null) {
      return Failure(
        LoginVerifyException(message: "Error on verify phone code, user null"),
      );
    }

    return Success(
      UserApiModel(
        name: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
      ),
    );
  }

  @override
  Future<void> logout() async {
    return await auth.signOut();
  }
}
