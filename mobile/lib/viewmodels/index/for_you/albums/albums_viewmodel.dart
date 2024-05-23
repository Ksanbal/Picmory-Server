import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/utils/show_confirm_delete.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/repositories/album_repository.dart';
import 'package:picmory/repositories/meory_repository.dart';

class AlbumsViewmodel extends ChangeNotifier {
  AlbumsViewmodel(this._id) {
    getAlbum();
    getMemoryList();

    scrollController.addListener(() {
      final isScrolled = scrollController.hasClients && scrollController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }
    });
  }

  final int _id;

  final AlbumRepository _albumRepository = AlbumRepository();
  final MemoryRepository _memoryRepository = MemoryRepository();

  final ScrollController scrollController = ScrollController();

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  AlbumModel? _album;
  AlbumModel? get album => _album;

  final List<MemoryListModel> _memories = [];
  List<MemoryListModel> get memories => _memories;

  getAlbum() async {
    final item = await _albumRepository.retrieve(
      userId: supabase.auth.currentUser!.id,
      albumId: _id,
    );

    _album = item;
    notifyListeners();
  }

  getMemoryList() async {
    final items = await _memoryRepository.list(
      userId: supabase.auth.currentUser!.id,
      albumId: _id,
    );

    _memories.addAll(items);
    notifyListeners();
  }

  delete(BuildContext context) async {
    final result = await showConfirmDelete(context);

    if (result != null && result) {
      await _albumRepository.delete(
        userId: supabase.auth.currentUser!.id,
        albumId: _id,
      );

      // 삭제 후 이전 페이지로 이동
      context.pop();
    }
  }
}
