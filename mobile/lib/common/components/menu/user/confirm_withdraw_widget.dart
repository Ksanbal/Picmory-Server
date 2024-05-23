import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmWithdrawWidget extends StatelessWidget {
  const ConfirmWithdrawWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('회원탈퇴'),
      content: const Text('정말로 회원탈퇴 하시겠습니까?'),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () => context.pop(false),
        ),
        TextButton(
          child: const Text('확인'),
          onPressed: () => context.pop(true),
        ),
      ],
    );
  }
}
