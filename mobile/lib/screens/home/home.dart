import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로그아웃
            TextButton(
              onPressed: () => authVM.signout().then(
                (result) {
                  if (result) {
                    context.go('/signin');
                  }
                },
              ),
              child: const Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
