import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Center(
        child: Column(
          children: [
            // 로그아웃
            TextButton(
              onPressed: () {},
              child: const Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
