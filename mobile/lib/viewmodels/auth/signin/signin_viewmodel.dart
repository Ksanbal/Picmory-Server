import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picmory/common/utils/show_loading.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/auth/access_token_model.dart';
import 'package:picmory/repositories/api/auth_repository.dart';
import 'package:picmory/repositories/api/members_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninViewmodel extends ChangeNotifier {
  SigninViewmodel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadLatestSigninProvider();
    });
  }

  final _authRepository = AuthRepository();
  final _memberRepository = MembersRepository();

  final storage = const FlutterSecureStorage();

  String? _latestSigninProvider;
  String? get latestSigninProvider => _latestSigninProvider;

  bool _loadProvider = false;
  bool get loadProvider => _loadProvider;

  /// 구글 로그인
  signinWithGoogle(BuildContext context) async {
    showLoading(context);

    try {
      final provider = 'GOOGLE';

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) throw 'No googleUser';

      final providerId = googleUser.id;
      final email = googleUser.email;
      final name = googleUser.displayName ?? '';
      final metadata = {
        "id": googleUser.id,
        "displayName": googleUser.displayName,
        "photo": googleUser.photoUrl,
        "email": googleUser.email,
      };

      await _signin(
        context,
        provider,
        providerId,
        email,
        name,
        metadata,
      );
    } catch (error) {
      log(
        error.toString(),
        name: 'signinWithGoogle',
        error: error,
      );
    } finally {
      removeLoading();
    }
  }

  /// 애플 로그인
  signinWithApple(BuildContext context) async {
    showLoading(context);
    try {
      final provider = 'APPLE';

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) throw 'No ID Token found.';

      if (credential.userIdentifier == null) throw 'No userIdentifier';

      final providerId = credential.userIdentifier!;

      // jwt 디코딩
      List<String> jwt = credential.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));

      final email = userInfo['email'];
      final metadata = userInfo;

      var name = email.split('@')[0];
      if (credential.familyName != null && credential.givenName != null) {
        name = "${credential.familyName} ${credential.givenName}";
      }

      await _signin(
        context,
        provider,
        providerId,
        email,
        name,
        metadata,
      );
    } catch (error) {
      log(
        error.toString(),
        name: 'signInWithApple',
        error: error,
      );
    } finally {
      removeLoading();
    }
  }

  _signin(
    BuildContext context,
    String provider,
    String providerId,
    String email,
    String name,
    Map<String, dynamic> metadata,
  ) async {
    final fcmToken = await messaging.getToken();
    if (fcmToken == null) throw 'No FCM Token';

    final res = await _authRepository.signin(
      provider: provider,
      providerId: providerId,
      fcmToken: fcmToken,
    );

    if (res.success) {
      // 로그인 성공
      _afterSucessSignin(context, provider, res.data!);
    } else if (res.statusCode == 404) {
      // 회원가입 진행
      final signupRes = await _memberRepository.signup(
        provider: provider,
        providerId: providerId,
        email: email,
        name: name,
        metadata: metadata,
      );

      if (signupRes.success) {
        // 회원가입 성공시 로그인 시도
        final signinRes = await _authRepository.signin(
          provider: provider,
          providerId: providerId,
          fcmToken: fcmToken,
        );

        if (signinRes.success) {
          // 로그인 성공
          analytics.logSignUp(signUpMethod: provider); // 회원가입 로깅
          _afterSucessSignin(context, provider, signinRes.data!);
        } else {
          showSnackBar(context, "로그인에 실패하였습니다");
        }
      }
    } else {
      // 로그인 실패
      showSnackBar(context, "로그인에 실패하였습니다");
    }
  }

  _afterSucessSignin(
    BuildContext context,
    String provider,
    AccessTokenModel token,
  ) async {
    analytics.logLogin(loginMethod: provider); // 로그인 로깅

    globalAccessToken = token;
    await storage.write(key: 'accessToken', value: globalAccessToken?.accessToken);
    await storage.write(key: 'refreshToken', value: globalAccessToken?.refreshToken);
    await storage.write(key: 'latestSigninProvider', value: provider);

    context.go('/');
  }

  /// 최근 로그인한 로그인 방식 표시
  loadLatestSigninProvider() async {
    _latestSigninProvider = await storage.read(key: 'latestSigninProvider');
    _loadProvider = true;

    notifyListeners();
  }
}
