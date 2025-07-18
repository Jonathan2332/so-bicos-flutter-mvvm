import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result_dart/result_dart.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository.dart';
import 'package:so_bicos/core/domain/models/auth/errors.dart';
import 'package:so_bicos/core/domain/models/auth/user.dart';
import 'package:so_bicos/ui/designsystem/localization/app_localizations.dart';
import 'package:so_bicos/ui/auth/auth_view_state.dart';
import 'package:so_bicos/ui/auth/login/viewmodels/login_viewmodel.dart';

import '../../../../fakes/core/external/models/user_api_model_fake.dart';
@GenerateNiceMocks([
  MockSpec<AuthRepository>(as: #AuthRepositoryMock),
  MockSpec<AppLocalizations>(as: #AppLocalizationsMock),
])
import 'login_viewmodel_test.mocks.dart';

void main() {
  late final AuthRepositoryMock repository;
  late final AppLocalizationsMock appLocalizations;
  late final LoginViewModel viewModel;

  final nameTest = "Jonathan";
  final emailTest = "jonathan@gmail.com";
  final passwordTest = "123456";
  final phoneNumberTest = "1234567";

  final user = User(
    name: nameTest,
    email: emailTest,
    phoneNumber: phoneNumberTest,
  );

  setUpAll(() {
    repository = AuthRepositoryMock();
    appLocalizations = AppLocalizationsMock();
    viewModel = LoginViewModel(
      authRepository: repository,
      appLocalizations: appLocalizations,
    );
  });

  group('getEmailValidatorMessage', () {
    test('message should be null', () async {
      final email = userApiModelFake.email;
      expect(viewModel.getEmailValidatorMessage(email), isNull);
    });

    test(
      'message should be AppLocalizations.this_field_requires_a_valid_email',
      () async {
        final email = "123";
        expect(
          viewModel.getEmailValidatorMessage(email),
          appLocalizations.this_field_requires_a_valid_email,
        );
      },
    );

    test(
      'message should be AppLocalizations.this_field_cant_be_empty_or_blank',
      () async {
        final email = "";
        expect(
          viewModel.getEmailValidatorMessage(email),
          appLocalizations.this_field_cant_be_empty_or_blank,
        );
      },
    );
  });

  group('getPasswordValidatorMessage', () {
    test('message should be null', () async {
      final password = "123456";
      expect(viewModel.getPasswordValidatorMessage(password), isNull);
    });

    test(
      'message should be AppLocalizations.this_field_cant_be_empty_or_blank',
      () async {
        final password = "";
        expect(
          viewModel.getPasswordValidatorMessage(password),
          appLocalizations.this_field_cant_be_empty_or_blank,
        );
      },
    );

    test(
      'message should be AppLocalizations.password_mus_be_at_least_characters',
      () async {
        final password = "12345";
        expect(
          viewModel.getPasswordValidatorMessage(password),
          appLocalizations.password_mus_be_at_least_characters,
        );
      },
    );
  });

  group('loginEmail', () {
    test('ViewState should be AuthSuccessState', () async {
      final Result<User> dummy = Success(user);
      provideDummy(dummy);

      when(
        repository.loginEmail(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);

      await viewModel.loginEmail((emailTest, passwordTest));

      expect(viewModel.viewState.value, isA<AuthSuccessState>());
    });

    test('ViewState should be AuthErrorState', () async {
      final Result<User> dummy = Failure(LoginEmailException(message: ""));
      provideDummy(dummy);

      when(
        repository.loginEmail(emailTest, passwordTest),
      ).thenAnswer((_) async => dummy);

      await viewModel.loginEmail((emailTest, passwordTest));

      expect(viewModel.viewState.value, isA<AuthErrorState>());
    });
  });
}
