// ignore_for_file: public_member_api_docs, sort_constructors_first
sealed class AuthViewState {}

class AuthIdleState implements AuthViewState {}

class AuthLoadingState implements AuthViewState {}

class AuthSuccessState implements AuthViewState {}

class AuthErrorState implements AuthViewState {
  String message;
  AuthErrorState({required this.message});
}
