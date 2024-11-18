import 'dart:developer';

import 'package:picmory/main.dart';
import 'package:picmory/models/api/albums/album_model.dart';

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
      log(e.toString(), name: 'AlbumRepository.create');
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
          .select('id, name, memory_album(id, memory(upload(uri, is_photo)))')
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
      log(e.toString(), name: 'AlbumRepository.list');
    }

    return [];
  }

  /// 앨범 개별 조회
  /// - [userId] : 사용자 Id
  /// - [albumId] : 앨범 Id
  Future<AlbumModel?> retrieve({
    required String userId,
    required int albumId,
  }) async {
    try {
      final data = await supabase
          .from('album')
          .select('id, name, memory_album(id, memory(photo_uri))')
          .eq('user_id', userId)
          .eq('id', albumId)
          .limit(1);

      if (data.isNotEmpty) {
        return AlbumModel.fromJson(data.first);
      }
    } catch (e) {
      log(e.toString(), name: 'AlbumRepository.retrieve');
    }
    return null;
  }

  /// 앨범 이름 수정
  /// - [userId] : 사용자 Id
  /// - [albumId] : 앨범 Id
  /// - [name] : 앨범 이름
  Future<bool> updateName({
    required String userId,
    required int albumId,
    required String name,
  }) async {
    try {
      await supabase
          .from('album')
          .update({
            'name': name,
          })
          .eq(
            'user_id',
            userId,
          )
          .eq(
            'id',
            albumId,
          );

      return true;
    } catch (e) {
      log(e.toString(), name: 'AlbumRepository.updateName');
    }
    return false;
  }

  /// 앨범 삭제
  /// - [userId] : 사용자 Id
  /// - [albumId] : 앨범 Id
  Future<bool> delete({
    required String userId,
    required int albumId,
  }) async {
    try {
      await supabase
          .from('album')
          .delete()
          .eq(
            'user_id',
            userId,
          )
          .eq(
            'id',
            albumId,
          );

      return true;
    } catch (e) {
      log(e.toString(), name: 'AlbumRepository.delete');
    }
    return false;
  }
}
