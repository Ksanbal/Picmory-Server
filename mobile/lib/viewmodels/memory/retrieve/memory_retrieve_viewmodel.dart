import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/album/add_album_bottomsheet.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/album_repository.dart';
import 'package:picmory/repositories/meory_repository.dart';

class MemoryRetrieveViewmodel extends ChangeNotifier {
  // Singleton instance
  static final MemoryRetrieveViewmodel _singleton = MemoryRetrieveViewmodel._internal();

  // Factory method to return the same instance
  factory MemoryRetrieveViewmodel() {
    return _singleton;
  }

  // Named constructor
  MemoryRetrieveViewmodel._internal();

  final MemoryRepository _memoryRepository = MemoryRepository();
  final AlbumRepository _albumRepository = AlbumRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;

  List<AlbumModel> _albums = [];

  bool _deleteComplete = false;
  bool get deleteComplete => _deleteComplete;

  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;

  /// 메모리 상세정보 호출
  getMemory(int memoryId) async {
    final data = await _memoryRepository.retrieve(
      userId: supabase.auth.currentUser!.id,
      memoryId: memoryId,
    );

    if (data != null) {
      _memory = data;
      notifyListeners();
    }
  }

  /// 좋아요 기록
  likeMemory() async {
    final result = await _memoryRepository.changeLikeStatus(
      userId: supabase.auth.currentUser!.id,
      memoryId: _memory!.id,
      isLiked: _memory!.isLiked,
    );

    if (result) {
      _memory!.isLiked = !_memory!.isLiked;
    }

    notifyListeners();
  }

  /// 삭제
  delete(BuildContext context) async {
    // [x] 삭제 확인 다이얼로그
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('삭제'),
          content: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    // [x] 삭제 요청
    if (result == true) {
      final error = await _memoryRepository.delete(
        userId: supabase.auth.currentUser!.id,
        memoryId: _memory!.id,
      );

      if (error != null) {
        showSnackBar(context, error);
      } else {
        showSnackBar(context, '삭제되었습니다.');

        _deleteComplete = true;

        // [x] 뒤로가기
        context.pop();
      }
    }
  }

  /// 전체화면 토글
  toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  /// 추억함에 추가 dialog 노출
  showAddAlbumDialog(BuildContext context) async {
    _albums = await _albumRepository.list(userId: supabase.auth.currentUser!.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddAlbumBottomsheet(
          albums: _albums,
          onCompleted: (ids) => addAlbum(context, ids),
          onCreateAlbum: () => createAlbumAndAdd(context),
        );
      },
    );
  }

  /// 추억함에 추가
  addAlbum(BuildContext context, List<int> albumIds) async {
    final result = await _memoryRepository.addToAlbum(
      userId: supabase.auth.currentUser!.id,
      memoryId: _memory!.id,
      albumIds: albumIds,
    );

    if (result) {
      context.pop();
      showSnackBar(
        context,
        '앨범에 추가되었습니다',
        bottomPadding: 96 - MediaQuery.of(context).padding.bottom,
        actionTitle: '완료',
      );
    }
  }

  createAlbumAndAdd(BuildContext context) async {
    context.pop();

    // 앨범 이름 입력 dialog 노출
    final TextEditingController controller = TextEditingController();

    var hintText = _memory?.brand ?? DateFormat('yyyy.MM').format(DateTime.now());

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CreateAlbumBottomsheet(
          controller: controller,
          hintText: hintText,
        );
      },
    );

    if (controller.text.isEmpty) {
      return;
    }

    final exist = _albums.any((e) => e.name == controller.text);
    if (exist) {
      showSnackBar(
        context,
        '이미 존재하는 이름입니다',
        bottomPadding: 96 - MediaQuery.of(context).padding.bottom,
        actionTitle: '닫기',
      );
      return;
    }

    final int? albumId = await _albumRepository.create(
      userId: supabase.auth.currentUser!.id,
      name: controller.text,
    );

    if (albumId == null) {
      showSnackBar(
        context,
        '앨범 생성에 실패했습니다',
        bottomPadding: 96 - MediaQuery.of(context).padding.bottom,
        actionTitle: '닫기',
      );
      return;
    }

    addAlbum(context, [albumId]);
  }

  pop(BuildContext context) {
    // 변수 초기화
    _memory = null;
    _deleteComplete = false;
    _isFullScreen = false;

    context.pop();
  }
}
