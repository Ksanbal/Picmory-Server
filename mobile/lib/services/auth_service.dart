import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picmory/datasources/local/auth_local_datasourece.dart';
import 'package:picmory/datasources/remote/auth_remote_datasource.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _authRemoteDatasource = AuthRemoteDatasource();
  final _authLocalDatasource = AuthLocalDataSource();

  /// 현재 로그인 유저
  User? get currentUser => _authLocalDatasource.getCurrenUser();

  /// 구글 로그인
  Future<bool> signInWithGoogle() async {
    try {
      final webClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID');

      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        serverClientId: webClientId,
      ).signIn();

      if (googleUser == null) {
        log(
          'Google Sign-In aborted by user.',
          name: 'signInWithGoogle',
        );
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        log(
          'No Access Token found.',
          name: 'signInWithGoogle',
        );
        return false;
      }
      if (idToken == null) {
        log(
          'No ID Token found.',
          name: 'signInWithGoogle',
        );

        return false;
      }

      return _authRemoteDatasource.signInWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      log(
        error.toString(),
        name: 'signInWithGoogle',
        error: error,
      );

      return false;
    }
  }

  /// 애플 로그인
  Future<bool> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        log(
          'No ID Token found.',
          name: 'signInWithApple',
        );

        return false;
      }

      return _authRemoteDatasource.signInWithApple(
        idToken: idToken,
      );
    } catch (error) {
      log(
        error.toString(),
        name: 'signInWithApple',
        error: error,
      );

      return false;
    }
  }

  /// 로그아웃
  Future<bool> signOut() async {
    return _authRemoteDatasource.signOut();
  }
}
