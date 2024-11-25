import 'package:picmory/models/api/albums/album_model.dart';

class AlbumDeleteMemoryEvent {
  AlbumModel album;

  AlbumDeleteMemoryEvent(this.album);
}
