import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/splash/splash_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SplashViewmodel>(context, listen: false);
    vm.init(context);

    return const Scaffold();
  }
}
