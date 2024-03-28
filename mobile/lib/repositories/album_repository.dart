import 'dart:developer';

import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';

/// 앨범 관련 서버 통신을 담당하는 클래스
class AlbumRepository {
  /// 앨범 리스트 조회
  /// - [userId] : 사용자 Id
  Future<List<AlbumModel>> list({
    required String userId,
  }) async {
    try {
      final data = await supabase
          .from('album')
          .select('id, name, memory_album(memory(photo_uri))')
          .eq('user_id', userId);

      if (data.isNotEmpty) {
        return data.map<AlbumModel>((e) => AlbumModel.fromJson(e)).toList();
      }
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.changeLikeStatus');
    }

    return [];
  }
}
