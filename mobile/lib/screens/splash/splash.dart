import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final authVM = Provider.of<AuthViewModel>(context, listen: false);

  /// 로그인 상태를 확인해서 로그인이면 홈으로, 로그인이 아니면 로그인으로 이동
  void _checkLoginStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authVM.getIsSignedIn()) {
        context.go('/home');
      } else {
        context.go('/signin');
      }
    });
  }

  @override
  void initState() {
    _checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
