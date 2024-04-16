import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/repositories/meory_repository.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';

class HomeViewmodel extends ChangeNotifier {
  final _memoryRepository = MemoryRepository();
  final MemoryCreateViewmodel _memoryCreateViewmodel;
  final MemoryRetrieveViewmodel _memoryRetrieveViewmodel;

  HomeViewmodel(this._memoryCreateViewmodel, this._memoryRetrieveViewmodel) {
    clearDatas();
    loadMemories();
    // loadHashtags();

    // 생성 리스너
    _memoryCreateViewmodel.addListener(() {
      if (_memoryCreateViewmodel.createComplete) {
        clearDatas();
        loadMemories();
      }
    });

    // 삭제 리스너
    _memoryRetrieveViewmodel.addListener(() {
      if (_memoryRetrieveViewmodel.deleteComplete) {
        _memories.removeWhere((element) => element.id == _memoryRetrieveViewmodel.memory!.id);
        notifyListeners();
      }
    });
  }

  /// 저장된 기억 목록
  final List<MemoryListModel> _memories = [];
  List<MemoryListModel> get memories => _memories;

  /// 해시태그 목록
  final List<String> _hashtags = [];
  List<String> get hashtags => _hashtags;

  final List<String> _selectedHashtags = [];
  List<String> get selectedHashtags => _selectedHashtags;

  // 그리드 crossAxisCount (1~3)
  int _crossAxisCount = 2;
  int get crossAxisCount => _crossAxisCount;

  /// 그리드 crossAxisCount 변경 (1~3)
  changeCrossAxisCount() {
    _crossAxisCount++;
    if (_crossAxisCount > 3) {
      _crossAxisCount = 1;
    }
    notifyListeners();
  }

  loadMemories({
    List<String> hashtags = const [],
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final items = await _memoryRepository.list(
      userId: userId,
      albumID: null,
      hashtags: hashtags,
    );

    _memories.addAll(items);
    notifyListeners();
  }

  clearDatas() {
    _memories.clear();
    _hashtags.clear();
  }

  deleteMemoryFromList(int memoryId) {
    _memories.removeWhere((element) => element.id == memoryId);
    notifyListeners();
  }

  // 2024.04.16 - 해시태그 기능은 추후 추가 예정
  // /// 해시태그 목록 불러오기
  // loadHashtags() async {
  //   final userId = supabase.auth.currentUser!.id;
  //   final items = await _memoryRepository.getHashtags(userId: userId);

  //   _hashtags.addAll(items);
  //   notifyListeners();
  // }

  // /// 해시태그 선택
  // onTapHashtags(String hashtag) async {
  //   if (_selectedHashtags.contains(hashtag)) {
  //     _selectedHashtags.remove(hashtag);
  //   } else {
  //     _selectedHashtags.add(hashtag);
  //   }

  //   _memories.clear();
  //   loadMemories(hashtags: _selectedHashtags);

  //   notifyListeners();
  // }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryListModel memory) {
    context.push('/memory/${memory.id}');
  }
}
