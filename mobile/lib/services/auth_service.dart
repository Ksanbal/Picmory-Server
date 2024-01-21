import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picmory/datasources/remote/auth_remote_datasources.dart';

class AuthService {
  final _authRemoteDatasource = AuthRemoteDatasource();

  /// 구글 로그인
  Future<bool> signinWithGoogle() async {
    try {
      final webClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID');

      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        serverClientId: webClientId,
      ).signIn();

      if (googleUser == null) {
        throw 'Google Sign-In aborted by user.';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      return _authRemoteDatasource.signinWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      log(error.toString());

      return false;
    }
  }
}
