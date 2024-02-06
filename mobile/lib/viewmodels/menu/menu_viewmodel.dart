import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/repositories/auth_repository.dart';

class MenuViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  /// 로그아웃
  signout(BuildContext context) async {
    _authRepository.signOut().then(
      (value) {
        if (value) {
          context.go('/auth/signin');
        }
      },
    );
  }
}
