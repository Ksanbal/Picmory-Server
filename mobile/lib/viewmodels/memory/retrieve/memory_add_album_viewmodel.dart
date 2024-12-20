import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/albums_repository.dart';

class MemoryAddAlbumViewmodel extends ChangeNotifier {
  MemoryAddAlbumViewmodel() {
    _loadAlbums();
  }

  final AlbumsRepository _albumsRepository = AlbumsRepository();

  // 앨범 목록
  final List<AlbumModel> _albums = [];
  List<AlbumModel> get albums => _albums;
  int _albumPage = 1;

  /// 앨범 목록 호출
  _loadAlbums() async {
    final result = await _albumsRepository.list(page: _albumPage);
    if (result.data == null) return null;

    albums.addAll(result.data!);

    notifyListeners();
  }

  /// 스크롤 마지막에 호출할 함수
  loadMore() {
    _albumPage++;
    _loadAlbums();
  }

  // 선택한 추억함 id 목록
  final List<int> _selectedAlbumIds = [];
  List<int> get selectedAlbumIds => _selectedAlbumIds;

  toggleSelectedAlbumIds(int id) {
    if (_selectedAlbumIds.contains(id)) {
      _selectedAlbumIds.remove(id);
    } else {
      _selectedAlbumIds.add(id);
    }
    notifyListeners();
  }

  /// 추억함에 추가
  addAlbum(BuildContext context, MemoryModel memory) async {
    int successCount = 0;
    for (final albumId in _selectedAlbumIds) {
      final result = await _albumsRepository.addMemory(
        id: albumId,
        memoryId: memory.id,
      );

      if (result.success) {
        successCount++;
      } else {
        showSnackBar(
          context,
          result.message,
          onPressedAction: () {},
        );
        break;
      }
    }

    context.pop();
    if (successCount == _selectedAlbumIds.length) {
      showSnackBar(
        context,
        '앨범에 추가되었습니다',
        onPressedAction: () {},
      );
    }
  }

  createAlbumAndAdd(BuildContext context, MemoryModel memory) async {
    // 앨범 이름 입력 dialog 노출
    var hintText = DateFormat('yyyy.MM').format(memory.date);
    if (memory.brandName.isNotEmpty) {
      hintText = memory.brandName;
    }

    final name = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CreateAlbumBottomsheet(
          hintText: hintText,
        );
      },
    );

    if (name == null) {
      return;
    }

    final result = await _albumsRepository.create(name: name);
    if (result.data == null) {
      showSnackBar(
        context,
        '앨범 생성에 실패했습니다',
        bottomPadding: 96 - MediaQuery.of(context).padding.bottom,
        actionTitle: '닫기',
      );
      return;
    }

    final addResult = await _albumsRepository.addMemory(
      id: result.data!.id,
      memoryId: memory.id,
    );

    if (addResult.success) {
      showSnackBar(
        context,
        '앨범에 추가되었습니다',
        onPressedAction: () {},
      );
    } else {
      return showSnackBar(
        context,
        result.message,
        onPressedAction: () {},
      );
    }

    context.pop();
  }
}
