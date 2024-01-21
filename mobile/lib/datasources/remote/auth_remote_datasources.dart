import 'dart:developer';

import 'package:picmory/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  /// 구글 로그인
  /// - [idToken] : 구글 로그인 시 발급되는 토큰
  /// - [accessToken] : 구글 로그인 시 발급되는 토큰
  Future<bool> signinWithGoogle({
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
}
