import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/memory/retrieve/add_album_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/change_date_bottomsheet.dart';
import 'package:picmory/common/components/memory/retrieve/video_player_dialog.dart';
import 'package:picmory/common/utils/show_confirm_delete.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/events/memory/delete_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/memories_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class MemoryRetrieveViewmodel extends ChangeNotifier {
  final MemoriesRepository _memoriesRepository = MemoriesRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;

  List<MemoryFileModel> get photos {
    if (memory == null) return [];
    return _memory!.files.where((element) => element.type == 'IMAGE').toList();
  }

  List<MemoryFileModel> get videos {
    if (memory == null) return [];
    return _memory!.files.where((element) => element.type == 'VIDEO').toList();
  }

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
        // 삭제 이벤트 발생
        eventBus.fire(MemoryDeleteEvent(_memory!));

        // [x] 뒤로가기
        context.pop();
      } else {
        showSnackBar(context, result.message);
      }
    }
  }

  /// 추억함에 추가 dialog 노출
  showAddAlbumDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddAlbumBottomsheet(
          memory: _memory!,
        );
      },
    );
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

    if (result.success) {
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
