import 'package:flutter/material.dart';
import 'package:picmory/views/index/create_memory/create_memory_view.dart';

class IndexViewmodel extends ChangeNotifier {
  /// 하단 바텀 네비게이션의 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// 하단 바텀 네비게이션의 인덱스 변경
  bottomNavigationHandler(BuildContext context, int value) {
    if (value == 1) {
      // QR코드 modal 노출
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const CreateMemoryView();
        },
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
      );
    } else {
      _currentIndex = value;
      notifyListeners();
    }
  }
}
