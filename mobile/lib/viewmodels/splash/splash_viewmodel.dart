import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/repositories/api/auth_repository.dart';

class SplashViewmodel extends ChangeNotifier {
  final _authRepository = AuthRepository();
  final _storage = const FlutterSecureStorage();

  init(BuildContext context) async {
    await _removeBadge();
    _checkAuthNRoute(context);
  }

  /// 로그인 상태를 불러와서 있으면 홈, 없으면 signin으로 라우팅
  _checkAuthNRoute(BuildContext context) async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    // build가 완전히 종료되고 나면 실행
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (refreshToken == null) {
          context.go('/auth/signin');
        } else {
          // accessToken 갱신 요청
          final result = await _authRepository.refresh(refreshToken: refreshToken);
          if (result.data == null) {
            context.go('/auth/signin');
          } else {
            final newAccessToken = result.data!.accessToken;
            await _storage.write(key: 'accessToken', value: newAccessToken);
            context.go('/');
          }
        }
      } finally {
        FlutterNativeSplash.remove();
      }
    });
  }

  /// 앱 뱃지 삭제
  _removeBadge() async {
    final isSupported = await AppBadgePlus.isSupported();
    if (isSupported) {
      await AppBadgePlus.updateBadge(0);
    }
  }
}
