import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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
    print('AppReviewViewmodel initialized');
    _loadMemoryCount();
    _subscribeToEvents();
    // resetCounter();
  }

  // 로컬에 저장된 추억 생성 횟수를 가져옵니다.
  Future<void> _loadMemoryCount() async {
    final countStr = await _storageRepository.read(StorageKey.memoryCreationCount);
    _memoryCreationCount = countStr != null ? int.parse(countStr) : 0;

    print('_loadMemoryCount: $_memoryCreationCount');
  }

  // 추억 생성 이벤트 구독
  void _subscribeToEvents() {
    print('_subscribeToEvents');
    _eventBus.on<MemoryCreateEvent>().listen((_) {
      print('_subscribeToEvents: MemoryCreateEvent');
      _onMemoryCreated();
    });
  }

  // 추억 생성 횟수를 증가시키고 3번이 넘으면 리뷰 요청합니다.
  Future<void> _onMemoryCreated() async {
    print('_onMemoryCreated');
    _memoryCreationCount++;
    await _storageRepository.write(
      StorageKey.memoryCreationCount,
      _memoryCreationCount.toString(),
    );

    if (_memoryCreationCount == _reviewThreshold) {
      _requestReview();
    }
  }

  // 리뷰 요청
  Future<void> _requestReview() async {
    final result = await showDialog<bool>(
      context: _context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰를 남겨주시겠어요?'),
        content: const Text('앱이 마음에 드셨다면 리뷰를 남겨주세요!'),
        actions: [
          TextButton(
            child: const Text('나중에'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('리뷰 남기기'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    print('result: $result');
    if (result == true) {
      // await _inAppReviewRepository.requestReview();
    }
  }

  // 테스트를 위한 카운터 초기화 메서드
  Future<void> resetCounter() async {
    _memoryCreationCount = 0;
    await _storageRepository.write(StorageKey.memoryCreationCount, '0');
  }
}
