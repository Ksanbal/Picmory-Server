import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:provider/provider.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SigninViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => vm.signinWithGoogle(context),
              child: const Text("구글 로그인"),
            ),
            TextButton(
              onPressed: () => vm.signinWithApple(context),
              child: const Text("애플 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
