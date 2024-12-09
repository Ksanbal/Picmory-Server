import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/album/create_album_bottomsheet.dart';
import 'package:picmory/common/utils/show_snackbar.dart';
import 'package:picmory/events/album/delete_event.dart';
import 'package:picmory/events/album/delete_memory_event.dart';
import 'package:picmory/events/album/edit_event.dart';
import 'package:picmory/events/memory/edit_event.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/repositories/api/albums_repository.dart';
import 'package:picmory/repositories/api/memories_repository.dart';

class ForYouViewmodel extends ChangeNotifier {
  ForYouViewmodel() {
    forYouViewController.addListener(() {
      // 상단 앱바 스타일 변경을 위한 스크롤 이벤트
      final isScrolled = forYouViewController.hasClients && forYouViewController.offset > 0;
      // 이전 상태와 다를 경우에만 변경
      if (isShrink != isScrolled) {
        isShrink = isScrolled;
        notifyListeners();
      }

      // 스크롤이 최하단에 도달하면 다음 페이지 로드
      if (forYouViewController.position.maxScrollExtent == forYouViewController.offset) {
        _page++;
        getAlbumList();
      }
    });

    // 앨범 삭제 이벤트
    eventBus.on<AlbumDeleteEvent>().listen((event) {
      log('AlbumDeleteEvent', name: 'ForYouViewmodel');
      _deleteAlbumFromList(event.album);
    });

    // 앨범내 추억 삭제 이벤트
    eventBus.on<AlbumDeleteMemoryEvent>().listen((event) {
      log('AlbumDeleteMemoryEvent', name: 'ForYouViewmodel');
      _updateAlbum(event.album);
    });

    // 앨범 수정 이벤트
    eventBus.on<AlbumEditEvent>().listen((event) {
      log('AlbumEditEvent', name: 'ForYouViewmodel');
      _updateAlbum(event.album);
    });

    // 기억 좋아요 취소 이벤트
    eventBus.on<MemoryEditEvent>().listen((event) {
      log('MemoryEditEvent', name: 'ForYouViewmodel');
      if (event.memory.like == false) {
        getLikeMemoryList();
      }
    });
  }

  init() {
    _page = 1;
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
    context.push('/for-you/like-memories');
  }

  /// 앨범 목록 페이지
  int _page = 1;

  /// 앨범 목록 로드
  getAlbumList() async {
    final result = await _albumsRepository.list(
      page: _page,
    );

    if (result.data == null) return;

    if (result.data!.isEmpty && (_albums ?? []).isEmpty) {
      _albums = null;
    } else {
      _albums = [..._albums ?? [], ...result.data!];
    }

    notifyListeners();
  }

  _reloadAlbumList() async {
    _page = 1;
    _albums?.clear();
    await getAlbumList();
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
      _memories = [...result.data!];
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
          hintText: '추억함 이름',
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

    await _reloadAlbumList();

    // 해당 앨범 페이지로 이동
    final index = _albums?.indexWhere((element) => element.id == result.data!.id);
    if (index == null) return;

    routeToAlbums(context, index);
  }

  /// 앨범 페이지로 이동
  routeToAlbums(BuildContext context, int index) async {
    final album = _albums![index];

    context.push('/for-you/albums/${album.id}', extra: album);
  }

  /// 특정 앨범을 목록에서 제거
  _deleteAlbumFromList(AlbumModel album) {
    _albums?.remove(album);

    if (_albums!.isEmpty) _albums = null;

    notifyListeners();
  }

  // 특정 앨범만 업데이트
  _updateAlbum(AlbumModel album) async {
    final result = await _albumsRepository.retrieve(id: album.id);
    if (result.data == null) return;

    final index = _albums?.indexWhere((element) => element.id == album.id);
    if (index == null) return;

    _albums?[index] = result.data!;
    notifyListeners();
  }
}
