import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/api/memories_repository.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';

class HomeViewmodel extends ChangeNotifier {
  final _memoriesRepository = MemoriesRepository();
  final MemoryCreateViewmodel _memoryCreateViewmodel;
  final MemoryRetrieveViewmodel _memoryRetrieveViewmodel;

  HomeViewmodel(this._memoryCreateViewmodel, this._memoryRetrieveViewmodel) {
    // 스크롤 이벤트 리스너
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        _page++;
        loadMemories();
      }
    });

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
        if (_memories == null) return;
        _memories?.removeWhere((element) => element.id == _memoryRetrieveViewmodel.memory!.id);
        notifyListeners();
      }
    });
  }

  init() {
    clearDatas();
    loadMemories();
  }

  /// 저장된 기억 목록
  List<MemoryModel>? _memories = [];
  List<MemoryModel>? get memories => _memories;

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

  // 로드할 페이지
  int _page = 1;
  ScrollController scrollController = ScrollController();

  // 메모리 목록 불러오기
  loadMemories({
    List<String> hashtags = const [],
  }) async {
    final result = await _memoriesRepository.list(
      page: _page,
    );
    if (result.data == null) return;

    if (result.data!.isEmpty) {
      _memories = null;
    } else {
      _memories?.addAll(result.data! as Iterable<MemoryModel>);
    }

    notifyListeners();
  }

  clearDatas() {
    _memories?.clear();
  }

  deleteMemoryFromList(int memoryId) {
    _memories?.removeWhere((element) => element.id == memoryId);
    notifyListeners();
  }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryListModel memory) {
    context.push('/memory/${memory.id}');
  }
}
