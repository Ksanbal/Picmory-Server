import 'dart:developer';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/components/common/modal_comp.dart';
import 'package:picmory/events/memory/create_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/internal/in_app_review_repository.dart';
import 'package:picmory/repositories/internal/storage_repository.dart';

class AppReviewViewmodel extends ChangeNotifier {
  static const int _reviewThreshold = 3;

  final StorageRepository _storageRepository = StorageRepository();
  final InAppReviewRepository _inAppReviewRepository = InAppReviewRepository();
  final EventBus _eventBus = eventBus;
  final BuildContext _context;

  int _memoryCreationCount = 0;

  AppReviewViewmodel({
    required BuildContext context,
  }) : _context = context {
    log('AppReviewViewmodel initialized');
    // resetCounter();
    _loadMemoryCount();
    _subscribeToEvents();
  }

  // 로컬에 저장된 추억 생성 횟수를 가져옵니다.
  Future<void> _loadMemoryCount() async {
    final countStr = await _storageRepository.read(StorageKey.memoryCreationCount);
    _memoryCreationCount = countStr != null ? int.parse(countStr) : 0;

    log('_loadMemoryCount: $_memoryCreationCount');
  }

  // 추억 생성 이벤트 구독
  void _subscribeToEvents() {
    log('_subscribeToEvents');
    _eventBus.on<MemoryCreateEvent>().listen((_) {
      log('_subscribeToEvents: MemoryCreateEvent');
      _onMemoryCreated();
    });
  }

  // 추억 생성 횟수를 증가시키고 3번이 넘으면 리뷰 요청합니다.
  Future<void> _onMemoryCreated() async {
    _memoryCreationCount++;
    await _storageRepository.write(
      StorageKey.memoryCreationCount,
      _memoryCreationCount.toString(),
    );

    log('_onMemoryCreated : $_memoryCreationCount');

    if (_memoryCreationCount == _reviewThreshold) {
      await _requestReview();
    }
  }

  // 리뷰 요청
  Future<void> _requestReview() async {
    log('_requestReview');
    // 리뷰요청 Event 기록
    analytics.logEvent(
      name: 'request_review',
      parameters: {
        'status': 'requested',
      },
    );

    // 1초 대기
    await Future.delayed(const Duration(milliseconds: 2000));

    final result = await showDialog<bool>(
      context: _context,
      builder: (context) => ModalComp(
        title: "벌써 세번이나\n추억을 담아주셨어요!",
        body: "앱 사용 경험을 공유해주세요.",
        confirmText: "리뷰할게요",
        cancelText: "괜찮아요",
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    log('_requestReview result: $result');

    if (result == true) {
      await _inAppReviewRepository.requestReview();

      await analytics.logEvent(
        name: 'request_review',
        parameters: {
          'status': 'confirmed',
        },
      );
    } else if (result == false) {
      await analytics.logEvent(
        name: 'request_review',
        parameters: {
          'status': 'declined',
        },
      );
    } else {
      await analytics.logEvent(
        name: 'request_review',
        parameters: {
          'status': 'cancelled',
        },
      );
    }
  }

  // 테스트를 위한 카운터 초기화 메서드
  Future<void> resetCounter() async {
    _memoryCreationCount = 2;
    await _storageRepository.write(StorageKey.memoryCreationCount, '2');
  }
}
