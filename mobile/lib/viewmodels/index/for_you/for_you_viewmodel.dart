import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/repositories/album_repository.dart';
import 'package:picmory/repositories/meory_repository.dart';

class ForYouViewmodel extends ChangeNotifier {
  ForYouViewmodel() {
    getAlbumList();
    getLikeMemoryList();

    forYouViewController.addListener(() {
      final isScrolled = forYouViewController.hasClients && forYouViewController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }
    });
  }

  final AlbumRepository _albumRepository = AlbumRepository();
  final MemoryRepository _memoryRepository = MemoryRepository();

  final List<AlbumModel> _albums = [];
  List<AlbumModel> get albums => _albums;

  final List<MemoryListModel> _memories = [];
  List<MemoryListModel> get memories => _memories;

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

  /// 앨범 목록 로드
  getAlbumList() async {
    final items = await _albumRepository.list(userId: supabase.auth.currentUser!.id);
    _albums.clear();
    _albums.addAll(items);
    notifyListeners();
  }

  /// 좋아요한 기억 목록 로드
  getLikeMemoryList() async {
    final items = await _memoryRepository.listOnlyLike(userId: supabase.auth.currentUser!.id);
    _memories.clear();
    _memories.addAll(items);
    notifyListeners();
  }

  /// 기억 상세 페이지로 이동
  goToMemoryRetrieve(BuildContext context, MemoryListModel memory) {
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

    // 해당 앨범 페이지로 이동
    routeToAlbums(context, albumId);
  }

  /// 앨범 페이지로 이동
  routeToAlbums(BuildContext context, int id) async {
    await context.push('/for-you/albums/$id');

    // 앨범 목록 다시 로드
    getAlbumList();
  }
}
