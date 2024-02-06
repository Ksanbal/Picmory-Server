import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/meory_repository.dart';

class HomeViewmodel extends ChangeNotifier {
  final _memoryRepository = MemoryRepository();

  /// 저장된 기억 목록
  final List<MemoryModel> _memories = [];
  List<MemoryModel> get memories => _memories;

  loadMemories() async {
    final userId = supabase.auth.currentUser!.id;
    final items = await _memoryRepository.list(
      userId: userId,
      albumID: null,
      hashtag: null,
    );

    _memories.addAll(items);
    notifyListeners();
  }

  clearMemories() {
    _memories.clear();
  }
}
