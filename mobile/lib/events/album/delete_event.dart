import 'package:picmory/models/api/albums/album_model.dart';

class AlbumDeleteEvent {
  AlbumModel album;

  AlbumDeleteEvent(this.album);
}
