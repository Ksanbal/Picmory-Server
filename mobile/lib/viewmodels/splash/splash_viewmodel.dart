import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/main.dart';

class SplashViewmodel extends ChangeNotifier {
  /// 로그인 상태를 불러와서 있으면 홈, 없으면 signin으로 라우팅
  checkAuthNRoute(BuildContext context) {
    final user = supabase.auth.currentUser;

    // build가 완전히 종료되고 나면 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      if (user == null) {
        context.go('/auth/signin');
      } else {
        context.go('/');
      }
    });
  }
}
