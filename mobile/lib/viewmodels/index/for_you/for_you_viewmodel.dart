import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/albums_repository.dart';
import 'package:picmory/repositories/api/memories_repository.dart';

class ForYouViewmodel extends ChangeNotifier {
  ForYouViewmodel() {
    forYouViewController.addListener(() {
      final isScrolled = forYouViewController.hasClients && forYouViewController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }
    });

    _albums?.clear();

    getAlbumList();
    getLikeMemoryList();
  }

  final AlbumsRepository _albumsRepository = AlbumsRepository();
  final MemoriesRepository _memoriesRepository = MemoriesRepository();

  List<AlbumModel>? _albums = [];
  List<AlbumModel>? get albums => _albums;

  List<MemoryModel>? _memories = [];
  List<MemoryModel>? get memories => _memories;

  // 추억함 페이지 전체 컨트롤러
  final ScrollController forYouViewController = ScrollController();

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  // 좋아요 페이지 컨트롤러
  final PageController likePageController = PageController();

  /// 메뉴 페이지로 이동
  routeToMenu(BuildContext context) {
    context.push('/menu');
  }

  /// 좋아요 페이지로 이동
  routeToLikeMemories(BuildContext context) async {
    await context.push('/for-you/like-memories');
    getLikeMemoryList();
  }

  /// 앨범 목록 페이지
  int _page = 1;

  /// 앨범 목록 로드
  getAlbumList() async {
    final result = await _albumsRepository.list(
      page: _page,
    );
    if (result.data == null) return;

    if (result.data!.isEmpty) {
      _albums = null;
    } else {
      _albums?.addAll(result.data!);
    }

    notifyListeners();
  }

  _reloadAlbumList() {
    _page = 1;
    _albums?.clear();
    getAlbumList();
  }

  /// 좋아요한 기억 목록 로드
  getLikeMemoryList() async {
    final result = await _memoriesRepository.list(
      limit: 5,
      like: true,
    );
    if (result.data == null) return;

    if (result.data!.isEmpty) {
      _memories = null;
    } else {
      _memories = [];
      _memories?.addAll(result.data!);
    }

    notifyListeners();
  }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryModel memory) {
    context.push('/memory/${memory.id}');
  }

  /// 앨범 생성 dialog 노출
  createAlbum(BuildContext context) async {
    // 앨범 이름 입력 dialog 노출
    final TextEditingController controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CreateAlbumBottomsheet(
          controller: controller,
          hintText: '앨범 이름',
        );
      },
    );

    if (controller.text.isEmpty) {
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

    _reloadAlbumList();

    // 해당 앨범 페이지로 이동
    routeToAlbums(context, result.data!.id);
  }

  /// 앨범 페이지로 이동
  routeToAlbums(BuildContext context, int id) async {
    await context.push('/for-you/albums/$id');

    // 앨범 목록 다시 로드
    _reloadAlbumList();
  }
}
