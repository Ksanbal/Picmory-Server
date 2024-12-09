import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/events/memory/delete_event.dart';
import 'package:picmory/events/memory/edit_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/memories_repository.dart';

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

    // 기억 좋아요 취소 이벤트 수신
    eventBus.on<MemoryEditEvent>().listen((event) {
      log('MemoryEditEvent', name: 'LikeMemoriesViewmodel');
      if (event.memory.like == false) {
        _memories.removeWhere((element) => element.id == event.memory.id);
        notifyListeners();
      }
    });

    // 기억 삭제 이벤트 수신
    eventBus.on<MemoryDeleteEvent>().listen((event) {
      log('MemoryDeleteEvent', name: 'LikeMemoriesViewmodel');
      _memories.removeWhere((element) => element.id == event.memory.id);
      notifyListeners();
    });
  }

  final MemoriesRepository _memoriesRepository = MemoriesRepository();

  final ScrollController scrollController = ScrollController();

  final List<MemoryModel> _memories = [];
  List<MemoryModel> get memories => _memories;

  int page = 1;

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  /// 좋아요한 기억 목록 로드
  getLikeMemoryList() async {
    final result = await _memoriesRepository.list(
      page: page,
      like: true,
    );

    if (result.success) {
      _memories.addAll(result.data!);
      notifyListeners();
    }
  }

  // 좋아요 취소
  unlikeMemory(MemoryModel memory) async {
    final result = await _memoriesRepository.edit(
      id: memory.id,
      like: !memory.like,
      date: memory.date,
      brandName: memory.brandName,
    );

    if (result.success) {
      eventBus.fire(MemoryEditEvent(memory));
      notifyListeners();
    }
  }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryModel memory) async {
    await context.push('/memory/${memory.id}');
  }
}
