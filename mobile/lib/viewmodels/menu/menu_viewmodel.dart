import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:picmory/common/components/menu/user/confirm_withdraw_widget.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/auth_repository.dart';

class MenuViewmodel extends ChangeNotifier {
  MenuViewmodel() {
    getUserInfo();
    getAppVersion();
  }

  final AuthRepository _authRepository = AuthRepository();

  /// 유저 정보
  String _userName = '';
  String get userName => _userName;

  String _provider = '';
  String get provider => _provider;

  /// 앱 버전
  String _appVersion = '';
  String get appVersion => _appVersion;

  /// 유저 정보 가져오기
  getUserInfo() async {
    final user = await supabase.auth.getUser();

    final appMetadata = user.user?.appMetadata;
    final userMetadata = user.user?.userMetadata;

    /// 로그인한 소셜로그인 정보에 따라서 분기
    if (appMetadata?['provider'] == 'google') {
      _provider = 'google';
      _userName = userMetadata?['full_name'] ?? '';
    } else if (appMetadata?['provider'] == 'apple') {
      _provider = 'apple';
      _userName = userMetadata?['email'].split('@')[0];
    }

    notifyListeners();
  }

  /// 앱 버전 가져오기
  getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;

    notifyListeners();
  }

  /// user 페이지로 이동
  routeToUser(BuildContext context) {
    context.push('/menu/user');
  }

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

  /**
   * user
   */
  /// 회원탈퇴
  withdraw(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmWithdrawWidget();
      },
    );

    if (result == null || !result) return;

    // [ ] 회원탈퇴 (supabase 그지 같네...)
    await supabase.auth.signOut();

    context.go('/auth/signin');
  }
}
