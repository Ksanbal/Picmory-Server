import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/repositories/album_repository.dart';

class ForYouViewmodel extends ChangeNotifier {
  ForYouViewmodel() {
    getList();

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

  final List<AlbumModel> _albums = [];
  List<AlbumModel> get albums => _albums;

  // 추억함 페이지 전체 컨트롤러
  final ScrollController forYouViewController = ScrollController();

  // 스크롤 최상단 여부 : 앱바 버튼의 스타일을 변경하기 위해서
  bool isShrink = false;

  // 좋아요 페이지 컨트롤러
  final PageController likePageController = PageController();

  routeToMenu(BuildContext context) {
    context.push('/menu');
  }

  getList() async {
    final items = await _albumRepository.list(userId: supabase.auth.currentUser!.id);
    _albums.clear();
    _albums.addAll(items);
    notifyListeners();
  }
}
