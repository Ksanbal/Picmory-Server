import 'package:picmory/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLocalDataSource {
  /// 현재 로그인 상태를 반환합니다.
  User? getCurrenUser() {
    return supabase.auth.currentUser;
  }
}
