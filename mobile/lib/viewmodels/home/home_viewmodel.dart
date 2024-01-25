import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  // 현재 로그인한 사용자
  final User? _currentUser = supabase.auth.currentUser;
  User? get currentUser => _currentUser;

  /// 로그아웃
  signout(BuildContext context) async {
    await _authRepository.signOut().then(
          (value) => value ? context.go('/auth/signin') : null,
        );
  }

  /// 메모리 생성 페이지로 이동
  goMemoryCreate(BuildContext context) {
    context.push('/memory/create');
  }
}
