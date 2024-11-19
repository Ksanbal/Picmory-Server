import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/album/add_album_bottomsheet.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/change_date_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/video_player_dialog.dart';
import 'package:picmory/common/utils/show_confirm_delete.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/albums_repository.dart';
import 'package:picmory/repositories/api/memories_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class MemoryRetrieveViewmodel extends ChangeNotifier {
  // Singleton instance
  static final MemoryRetrieveViewmodel _singleton = MemoryRetrieveViewmodel._internal();

  // Factory method to return the same instance
  factory MemoryRetrieveViewmodel() {
    return _singleton;
  }

  // Named constructor
  MemoryRetrieveViewmodel._internal();

  final MemoriesRepository _memoriesRepository = MemoriesRepository();
  final AlbumsRepository _albumsRepository = AlbumsRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;

  List<MemoryFileModel> get photos {
    if (memory == null) return [];
    // return _memory!.uploads.where((element) => element.isPhoto).toList();
    return _memory!.files.where((element) => element.type == 'IMAGE').toList();
  }

  List<MemoryFileModel> get videos {
    if (memory == null) return [];
    return _memory!.files.where((element) => element.type == 'VIDEO').toList();
  }

  List<AlbumModel> _albums = [];

  bool _deleteComplete = false;
  bool get deleteComplete => _deleteComplete;

  /// 메모리 상세정보 호출
  getMemory(int memoryId) async {
    final result = await _memoriesRepository.retrieve(
      id: memoryId,
    );

    if (result.data != null) {
      _memory = result.data;
      notifyListeners();
    }
  }

  /// 좋아요 기록
  likeMemory() async {
    if (_memory == null) return;

    final result = await _memoriesRepository.edit(
      id: _memory!.id,
      date: _memory!.date,
      brandName: _memory!.brandName,
      like: !_memory!.like, // toggle
    );

    if (result.success) {
      _memory!.like = !_memory!.like;
      notifyListeners();
    }
  }

  /// 삭제
  delete(BuildContext context) async {
    // [x] 삭제 확인 다이얼로그
    final result = await showConfirmDelete(context);

    // [x] 삭제 요청
    if (result == true) {
      final result = await _memoriesRepository.delete(
        id: _memory!.id,
      );

      if (result.success) {
        showSnackBar(context, '삭제되었습니다.');

        _deleteComplete = true;

        // [x] 뒤로가기
        context.pop();
      } else {
        showSnackBar(context, result.message);
      }
    }
  }

  /// 추억함에 추가 dialog 노출
  showAddAlbumDialog(BuildContext context) async {
    final result = await _albumsRepository.list();
    if (result.data == null) return;

    _albums = result.data!;

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
    final results = await Future.wait(
      albumIds.map(
        (id) => _albumsRepository.addMemory(
          id: id,
          memoryId: _memory!.id,
        ),
      ),
    );

    if (results.any((e) => !e.success)) {
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

    var hintText = _memory?.brandName ?? DateFormat('yyyy.MM').format(DateTime.now());

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

    final result = await _albumsRepository.create(name: controller.text);
    if (result.data == null) {
      showSnackBar(
        context,
        '앨범 생성에 실패했습니다',
        bottomPadding: 96 - MediaQuery.of(context).padding.bottom,
        actionTitle: '닫기',
      );
      return;
    }

    addAlbum(context, [result.data!.id]);
  }

  pop(BuildContext context) {
    // 변수 초기화
    _memory = null;
    _deleteComplete = false;

    context.pop();
  }

  showChangeDateBottomsheet(BuildContext context) async {
    final selectedDay = await showModalBottomSheet(
      context: context,
      builder: (BuildContext _) {
        return ChangeDateBottomsheet(
          focusedDay: _memory!.date,
          // focusedDay: DateTime(2024, 4, 20),
        );
      },
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
    );

    if (selectedDay == null || isSameDay(_memory!.date, selectedDay)) return;

    final result = await _memoriesRepository.edit(
      id: _memory!.id,
      date: selectedDay,
      brandName: _memory!.brandName,
      like: _memory!.like,
    );

    if (result.data != null) {
      _memory!.date = selectedDay;
      notifyListeners();
    }
  }

  // 비디오 재생 dialog
  showVideoPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return VideoPlayerDialog(
          uris: videos.map((e) => e.path).toList(),
        );
      },
    );
  }
}
