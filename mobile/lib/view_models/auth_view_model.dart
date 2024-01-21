import 'package:flutter/foundation.dart';

import 'package:picmory/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService authService = AuthService();

  AuthViewModel({
    required this.authService,
  });

  User? get currenUser => authService.currentUser;

  /// 현재 로그인 상태
  bool getIsSignedIn() {
    return authService.currentUser != null;
  }

  /// 구글 로그인
  Future<bool> signinWithGoogle() async {
    return await authService.signInWithGoogle();
  }

  /// 애플 로그인
  Future<bool> signinWithApple() async {
    return await authService.signInWithApple();
  }

  /// 로그아웃
  Future<bool> signout() async {
    return await authService.signOut();
  }
}
