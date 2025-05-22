import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract final class StorageKey {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';

  /// 마지막으로 로그인한 소셜로그인
  static const latestSigninProvider = 'latestSigninProvider';

  /// 메모리 생성 횟수
  static const memoryCreationCount = 'memoryCreationCount';
}

class StorageRepository {
  final storage = const FlutterSecureStorage();

  /// 추가
  write(String key, String value) async {
    await storage.write(key: key.toString(), value: value);
  }

  /// 읽기
  read(String key) async {
    return await storage.read(key: key.toString());
  }

  /// 삭제
  delete(String key) async {
    await storage.delete(key: key.toString());
  }
}
