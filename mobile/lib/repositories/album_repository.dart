import 'dart:developer';

import 'package:picmory/main.dart';
import 'package:picmory/models/album/album_model.dart';

/// 앨범 관련 서버 통신을 담당하는 클래스
class AlbumRepository {
  /// 앨범 생성
  /// - [userId] : 사용자 Id
  /// - [name] : 앨범 이름
  Future<int?> create({
    required String userId,
    required String name,
  }) async {
    try {
      final data = await supabase.from('album').insert({
        'user_id': userId,
        'name': name,
      }).select('id');

      return data.first['id'] as int;
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.create');
      return null;
    }
  }

  /// 앨범 리스트 조회
  /// - [userId] : 사용자 Id
  Future<List<AlbumModel>> list({
    required String userId,
  }) async {
    try {
      final data = await supabase
          .from('album')
          .select('id, name, memory_album(id, memory(photo_uri))')
          .eq('user_id', userId)
          .order('id', ascending: false);

      if (data.isNotEmpty) {
        return data.map<AlbumModel>((e) {
          // memroy_album의 id를 역순으로 정렬
          (e['memory_album'] as List<dynamic>).sort((a, b) {
            return a['id'] < b['id'] ? 1 : -1;
          });

          return AlbumModel.fromJson(e);
        }).toList();
      }
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.changeLikeStatus');
    }

    return [];
  }
}
