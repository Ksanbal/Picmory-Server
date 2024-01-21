import 'package:flutter/foundation.dart';

import 'package:picmory/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService authService = AuthService();

  AuthViewModel({
    required this.authService,
  });

  /// 구글 로그인
  Future<bool> signinWithGoogle() async {
    return await authService.signInWithGoogle();
  }

  /// 로그아웃
  Future<bool> signout() async {
    return await authService.signOut();
  }
}
