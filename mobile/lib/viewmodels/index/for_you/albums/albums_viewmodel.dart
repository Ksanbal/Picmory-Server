import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/repositories/meory_repository.dart';

class AlbumsViewmodel extends ChangeNotifier {
  AlbumsViewmodel(this._id) {
    getMemoryList();

    scrollController.addListener(() {
      final isScrolled = scrollController.hasClients && scrollController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }
    });
  }

  final int _id;

  final MemoryRepository _memoryRepository = MemoryRepository();

  final ScrollController scrollController = ScrollController();

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  final List<MemoryListModel> _memories = [];
  List<MemoryListModel> get memories => _memories;

  getMemoryList() async {
    final items = await _memoryRepository.list(
      userId: supabase.auth.currentUser!.id,
      albumId: _id,
    );

    _memories.addAll(items);
    notifyListeners();
  }
}
