import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/repositories/album_repository.dart';

class ForYouViewmodel extends ChangeNotifier {
  final AlbumRepository _albumRepository = AlbumRepository();

  final List<AlbumModel> _albums = [];
  List<AlbumModel> get albums => _albums;

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
