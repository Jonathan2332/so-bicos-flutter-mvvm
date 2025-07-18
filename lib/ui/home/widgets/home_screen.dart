import 'package:flutter/material.dart';
import 'package:so_bicos/ui/home/viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton.filledTonal(onPressed: () {
          viewModel.signout();
        }, icon: Icon(Icons.logout))],
      ),
      body: Center(),
    );
  }
}
