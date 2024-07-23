import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IndexViewmodel extends ChangeNotifier {
  /// 하단 바텀 네비게이션의 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// 하단 바텀 네비게이션의 인덱스 변경
  bottomNavigationHandler(BuildContext context, int value) {
    if (value == 1) {
      context.push('/memory/get-source');
    } else {
      _currentIndex = value;
      notifyListeners();
    }
  }
}
