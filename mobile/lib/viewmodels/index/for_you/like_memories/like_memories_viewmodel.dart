import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/repositories/memory_repository.dart';

class LikeMemoriesViewmodel extends ChangeNotifier {
  LikeMemoriesViewmodel() {
    getLikeMemoryList();

    scrollController.addListener(() {
      final isScrolled = scrollController.hasClients && scrollController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }

      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        page++;
        getLikeMemoryList();
      }
    });
  }

  final MemoryRepository _memoryRepository = MemoryRepository();

  final ScrollController scrollController = ScrollController();

  final List<MemoryListModel> _memories = [];
  List<MemoryListModel> get memories => _memories;

  int page = 1;

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  /// 좋아요한 기억 목록 로드
  getLikeMemoryList() async {
    final items = await _memoryRepository.listOnlyLike(
      userId: supabase.auth.currentUser!.id,
      page: page,
      pageCount: 20,
    );
    _memories.addAll(items);
    notifyListeners();
  }

  // 좋아요 취소
  unlikeMemory(int memoryId) async {
    final result = await _memoryRepository.changeLikeStatus(
      userId: supabase.auth.currentUser!.id,
      memoryId: memoryId,
      isLiked: true,
    );

    if (result) {
      _memories.removeWhere((element) => element.id == memoryId);
      notifyListeners();
    }
  }
}
