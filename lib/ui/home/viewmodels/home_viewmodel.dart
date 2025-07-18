import 'package:so_bicos/core/data/repositories/auth/auth_repository.dart';

class HomeViewModel {
  final AuthRepository authRepository;

  HomeViewModel({required this.authRepository});

  void signout() async => await authRepository.logout();
}
