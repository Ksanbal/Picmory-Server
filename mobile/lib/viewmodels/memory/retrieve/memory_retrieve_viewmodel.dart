import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/meory_repository.dart';

class MemoryRetrieveViewmodel extends ChangeNotifier {
  final MemoryRepository _memoryRepository = MemoryRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;

  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;

  /// 메모리 상세정보 호출
  getMemory(int memoryId) async {
    final data = await _memoryRepository.retrieve(
      userId: supabase.auth.currentUser!.id,
      memoryId: memoryId,
    );

    if (data != null) {
      _memory = data;
      notifyListeners();
    }
  }

  /// 좋아요 기록
  likeMemory() async {
    final result = await _memoryRepository.changeLikeStatus(
      userId: supabase.auth.currentUser!.id,
      memoryId: _memory!.id,
      isLiked: _memory!.isLiked,
    );

    if (result) {
      _memory!.isLiked = !_memory!.isLiked;
    }

    notifyListeners();
  }

  /// 삭제
  delete(BuildContext context) async {
    // [ ] 삭제 확인 다이얼로그

    // [ ] 삭제 요청
  }

  toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }
}
