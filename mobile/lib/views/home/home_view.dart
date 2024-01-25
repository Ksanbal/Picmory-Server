import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 현재 로그인한 사용자 정보
            Text(
              "uuid : ${vm.currentUser?.id ?? 'null'}",
            ),
            Text(
              "이메일 : ${vm.currentUser?.email ?? 'null'}",
            ),
            // 로그아웃
            TextButton(
              onPressed: () => vm.signout(context),
              child: const Text("로그아웃"),
            ),
            // 갤러리에서 사진 선택
            TextButton(
              onPressed: () => vm.goMemoryCreate(context),
              child: const Text("메모리 생성"),
            ),
          ],
        ),
      ),
    );
  }
}
