import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/components/album/add_album_bottomsheet.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/change_date_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/video_player_dialog.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/models/memory/memory_upload_model.dart';
import 'package:picmory/repositories/album_repository.dart';
import 'package:picmory/repositories/meory_repository.dart';
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

  final MemoryRepository _memoryRepository = MemoryRepository();
  final AlbumRepository _albumRepository = AlbumRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;

  List<MemoryUploadModel> get photos {
    if (memory == null) return [];
    return _memory!.uploads.where((element) => element.isPhoto).toList();
  }

  List<MemoryUploadModel> get videos {
    if (memory == null) return [];
    return _memory!.uploads.where((element) => !element.isPhoto).toList();
  }

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
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 86),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  onPressed: () => context.pop(true),
                  backgroundColor: Colors.white,
                  child: const Text(
                    "삭제",
                    style: TextSmStyle(
                      color: ColorFamily.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  onPressed: () => context.pop(false),
                  backgroundColor: Colors.white,
                  child: const Text(
                    "취소",
                    style: TextSmStyle(
                      color: ColorFamily.textGrey700,
                    ),
                  ),
                ),
              ),
            ],
          ),
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

    final result = await _memoryRepository.edit(
      userId: supabase.auth.currentUser!.id,
      memoryId: _memory!.id,
      date: selectedDay,
    );

    if (result) {
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
          uris: videos.map((e) => e.uri).toList(),
        );
      },
    );
  }
}
