// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class AuthException implements Exception {
  String get message;
}

class CreateUserException implements AuthException {
  @override
  String message;
  CreateUserException({
    required this.message,
  });
}

class LoggedUserException implements AuthException {
  @override
  String message;
  LoggedUserException({
    required this.message,
  });
}

class LoginEmailException implements AuthException {
  @override
  String message;
  LoginEmailException({
    required this.message,
  });
}

class LoginPhoneException implements AuthException {
  @override
  String message;
  LoginPhoneException({
    required this.message,
  });
}

class LoginVerifyException implements AuthException {
  @override
  String message;
  LoginVerifyException({
    required this.message,
  });
}

class LogoutException implements AuthException {
  @override
  String message;
  LogoutException({
    required this.message,
  });
}

class InvalidEmailException implements AuthException {
  @override
  String message;
  InvalidEmailException({
    required this.message,
  });
}