import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:so_bicos/core/data/datasources/auth/auth_datasource.dart';
import 'package:so_bicos/core/external/datasources/auth/firebase_datasource_impl.dart';

List<SingleChildWidget> get externalDependencies {
  return [
    Provider(create: (context) => FirebaseAuth.instance),
    Provider(create: (context) => FirebaseDataSourceImpl(auth: context.read()) as AuthDataSource),
  ];
}