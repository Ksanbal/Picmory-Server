import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/events/memory/create_event.dart';
import 'package:picmory/events/memory/delete_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/memories_repository.dart';

class HomeViewmodel extends ChangeNotifier {
  final _memoriesRepository = MemoriesRepository();

  HomeViewmodel() {
    // 스크롤이 바닥에 닿았을때 다음 페이지 로드
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        _page++;
        loadMemories();
      }
    });

    // 추억 생성 이벤트 리스너
    eventBus.on<MemoryCreateEvent>().listen((event) {
      log('MemoryCreateEvent', name: 'HomeViewmodel');
      init();
    });

    // 추억 삭제 이벤트 리스너
    eventBus.on<MemoryDeleteEvent>().listen((event) {
      log('MemoryDeleteEvent', name: 'HomeViewmodel');
      _onDeleteMemory(event.memory.id);
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

    if (result.data!.isEmpty && (_memories ?? []).isEmpty) {
      _memories = null;
    } else {
      _memories = [..._memories ?? [], ...result.data!];
    }

    notifyListeners();
  }

  clearDatas() {
    _page = 1;
    _memories?.clear();
  }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryModel memory) {
    context.push('/memory/${memory.id}');
  }

  _onDeleteMemory(int memoryId) {
    _memories?.removeWhere((element) => element.id == memoryId);
    if (_memories?.isEmpty ?? false) {
      _memories = null;
    }

    notifyListeners();

    // TODO: 삭제 스낵바 노출
    // showSnackBar(context, '삭제되었습니다.');
  }
}
