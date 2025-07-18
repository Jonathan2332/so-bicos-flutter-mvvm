import 'package:flutter/material.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository.dart';
import 'package:so_bicos/ui/auth/auth_view_state.dart';
import 'package:so_bicos/ui/designsystem/localization/app_localizations.dart';
import 'package:string_validator/string_validator.dart' as validator;

class SignupViewModel {
  final AppLocalizations appLocalizations;
  final AuthRepository authRepository;

  SignupViewModel({
    required this.authRepository,
    required this.appLocalizations,
  });

  final ValueNotifier<bool> obscureTextPassword = ValueNotifier(true);
  final ValueNotifier<AuthViewState> viewState = ValueNotifier(AuthIdleState());
  final ValueNotifier<bool> obscureTextPasswordConfirm = ValueNotifier(true);

  String? getEmailValidatorMessage(String? text) {
    if (text == null || text.isEmpty) {
      return appLocalizations.this_field_cant_be_empty_or_blank;
    } else if (!validator.isEmail(text)) {
      return appLocalizations.this_field_requires_a_valid_email;
    }

    return null;
  }

  String? getPasswordValidatorMessage(String? text) {
    if (text == null || text.isEmpty) {
      return appLocalizations.this_field_cant_be_empty_or_blank;
    } else if (text.length < 6) {
      return appLocalizations.password_mus_be_at_least_characters;
    }

    return null;
  }

  String? getPasswordConfirmValidatorMessage(String? text, String password) {
    if (text == null || text.isEmpty) {
      return appLocalizations.this_field_cant_be_empty_or_blank;
    } else if (text.length < 6) {
      return appLocalizations.password_mus_be_at_least_characters;
    } else if (!text.equals(password)) {
      return appLocalizations.passwords_dont_match;
    }

    return null;
  }

  Future<void> signupWithCredentials((String, String) credentials) async {
    viewState.value = AuthLoadingState();
    final (email, password) = credentials;
    final result = await authRepository.createUser(email, password);
    result.fold(
      (user) {
        viewState.value = AuthSuccessState();
      },
      (failure) {
        viewState.value = AuthErrorState(
          message: result.exceptionOrNull()?.toString() ?? "Unknown",
        );
      },
    );
  }
}
