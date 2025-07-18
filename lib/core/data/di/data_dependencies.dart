import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository.dart';
import 'package:so_bicos/core/data/repositories/auth/auth_repository_impl.dart';

List<SingleChildWidget> get dataDependencies {
  return [
    ChangeNotifierProvider(create: (context) => AuthRepositoryImpl(dataSource: context.read()) as AuthRepository),
  ];
}