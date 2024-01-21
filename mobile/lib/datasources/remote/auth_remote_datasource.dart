import 'dart:developer';

import 'package:picmory/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  /// 구글 로그인
  /// - [idToken] : 구글 로그인 시 발급되는 토큰
  /// - [accessToken] : 구글 로그인 시 발급되는 토큰
  Future<bool> signInWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    log(response.user.toString());

    return response.user != null;
  }

  /// 애플 로그인
  /// - [idToken] : 애플 로그인 시 발급되는 토큰
  /// - [nonce] : 애플 로그인 시 발급되는 토큰
  Future<bool> signInWithApple({
    required String idToken,
  }) async {
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
    );

    log(response.user.toString());

    return response.user != null;
  }

  /// 로그아웃
  Future<bool> signOut() async {
    await supabase.auth.signOut();

    // 현재 로그인 상태 확인 후 결과 반환
    final session = supabase.auth.currentSession;
    log(session.toString());

    return session == null;
  }
}
