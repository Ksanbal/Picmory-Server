import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_confirm_delete.dart';
import 'package:picmory/events/album/delete_event.dart';
import 'package:picmory/events/album/delete_memory_event.dart';
import 'package:picmory/events/album/edit_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/albums_repository.dart';
import 'package:picmory/repositories/api/memories_repository.dart';

class AlbumsViewmodel extends ChangeNotifier {
  AlbumsViewmodel(this._id) {
    getMemoryList();

    scrollController.addListener(() {
      final isScrolled = scrollController.hasClients && scrollController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }

      // 스크롤이 최하단에 도달하면 다음 페이지 로드
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        _page++;
        getMemoryList();
      }
    });
  }

  final int _id;

  final AlbumsRepository _albumsRepository = AlbumsRepository();
  final MemoriesRepository _memoriesRepository = MemoriesRepository();

  final ScrollController scrollController = ScrollController();

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  AlbumModel? album;

  final List<MemoryModel> _memories = [];
  List<MemoryModel> get memories => _memories;

  int _page = 1;
  getMemoryList() async {
    final result = await _memoriesRepository.list(
      page: _page,
      albumId: _id,
    );

    if (result.success == false) return;

    _memories.addAll(result.data!);
    notifyListeners();
  }

  delete(BuildContext context) async {
    if (album == null) return;

    final result = await showConfirmDelete(context);

    if (result != null && result) {
      await _albumsRepository.delete(
        id: _id,
      );

      // 앨범 삭제 이벤트 발행
      eventBus.fire(AlbumDeleteEvent(album!));

      // 삭제 후 이전 페이지로 이동
      context.pop();
    }
  }

  deleteMemoryFromAlbum(BuildContext context, int memoryId) async {
    final delete = await showConfirmDelete(
      context,
      title: "앨범에서 삭제",
    );

    if (delete != null && delete) {
      final result = await _albumsRepository.deleteMemory(
        id: _id,
        memoryId: memoryId,
      );

      if (result.success) {
        // 삭제 후 리스트에서 제거
        _memories.removeWhere((element) => element.id == memoryId);

        // 앨범 속 메모리 삭제 이벤트 발생
        eventBus.fire(AlbumDeleteMemoryEvent(album!));

        notifyListeners();
      }
    }
  }

  /// 앨범명 수정
  editName(BuildContext context) async {
    if (album == null) return;

    final name = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CreateAlbumBottomsheet(
          hintText: album!.name,
        );
      },
    );

    if (name == null || name.isEmpty || name == album!.name) return;

    final result = await _albumsRepository.edit(id: album!.id, name: name);

    if (result.success) {
      album!.name = name;
      notifyListeners();

      eventBus.fire(AlbumEditEvent(album!));
    }
  }
}
