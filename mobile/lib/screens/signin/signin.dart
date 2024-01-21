import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => authVM.signinWithGoogle().then(
                (result) {
                  if (result) {
                    context.go('/home');
                  }
                },
              ),
              child: const Text("구글 로그인"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("애플 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
