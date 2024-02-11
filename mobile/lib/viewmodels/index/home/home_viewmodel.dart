import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/meory_repository.dart';

class HomeViewmodel extends ChangeNotifier {
  final _memoryRepository = MemoryRepository();

  /// 저장된 기억 목록
  final List<MemoryModel> _memories = [];
  List<MemoryModel> get memories => _memories;

  /// 해시태그 목록
  final List<String> _hashtags = [];
  List<String> get hashtags => _hashtags;

  final List<String> _selectedHashtags = [];
  List<String> get selectedHashtags => _selectedHashtags;

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

  /// 해시태그 목록 불러오기
  loadHashtags() async {
    final userId = supabase.auth.currentUser!.id;
    final items = await _memoryRepository.getHashtags(userId: userId);

    _hashtags.addAll(items);
    notifyListeners();
  }

  /// 해시태그 선택
  onTapHashtags(String hashtag) async {
    if (_selectedHashtags.contains(hashtag)) {
      _selectedHashtags.remove(hashtag);
    } else {
      _selectedHashtags.add(hashtag);
    }

    _memories.clear();
    loadMemories(hashtags: _selectedHashtags);

    notifyListeners();
  }
}
