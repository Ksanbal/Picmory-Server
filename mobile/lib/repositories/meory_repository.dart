import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/crawled_qr_model.dart';
import 'package:picmory/models/memory/memory_create_model.dart';
import 'package:picmory/models/memory/memory_list_model.dart';
import 'package:picmory/models/memory/memory_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// 기억 관련 서버 통신을 담당하는 클래스
class MemoryRepository {
  Future<String> _uploadFile(
    String path,
    String bucket,
    String filename,
    File file,
  ) async {
    final supabaseUrl = dotenv.get("SUPABASE_URL");

    final uri = await supabase.storage.from(bucket).upload(
          '$path/$filename',
          file,
        );

    return "$supabaseUrl/storage/v1/object/public/$uri";
  }

  /// 기억 생성
  /// - [userID] : 사용자 ID
  /// - [photo] : 사진
  /// - [video] : 영상
  /// - [hashTags] : 해시태그 목록
  /// - [date] : 날짜
  /// - [brand] : 브랜드
  Future<bool> create({
    required String userId,
    required File photo,
    required String photoName,
    required File? video,
    required String? videoName,
    required DateTime date,
    required String? brand,
  }) async {
    /** 
     * TODO: 기억 생성 기능 작성
     * - [x] photo, video 업로드 & URI 획득
     * - [x] memory 생성
     * - [x] hashtags 목록에서 DB에 없는 해시태그는 생성
     * - [x] memory_hashtag 생성
     */
    final now = DateTime.now();
    final path = 'users/$userId/memories/${now.millisecondsSinceEpoch}';

    try {
      final photoUri = await _uploadFile(
        path,
        'picmory',
        photoName,
        photo,
      );
      final videoUri = video != null && videoName != null
          ? await _uploadFile(
              path,
              'picmory',
              videoName,
              video,
            )
          : null;

      final newMemory = MemoryCreateModel(
        userId: userId,
        photoUri: photoUri,
        videoUri: videoUri,
        date: date,
        brand: brand,
      );

      await supabase
          .from('memory')
          .insert(
            newMemory.toJson(),
          )
          .select('id');

      return true;
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.create');
      return false;
    }
  }

  /// 목록 조회
  /// - [userId] : 사용자 ID
  /// - [albumID] : 앨범 ID
  /// - [hashtag] : 해시태그
  Future<List<MemoryListModel>> list({
    required String userId,
    required int? albumID,
    List<String> hashtags = const [],
  }) async {
    /**
     * TODO: 기억 목록 조회 기능 작성
     * - [x] albumID, hashtag가 모두 null이 아니면 에러
     * - [x] albumID, hashtag가 모두 null이면 전체 기억 목록 조회
     * - [ ] albumID가 null이 아니면 해당 앨범의 기억 목록 조회
     * - [ ] hashtag가 null이 아니면 해당 해시태그가 포함된 기억 목록 조회
     */
    if (albumID != null && hashtags.isEmpty) {
      throw Exception('albumID, hashtags 둘 중 하나만 입력해주세요');
    }

    final result = [];
    if (albumID == null && hashtags.isEmpty) {
      final items = await supabase
          .from('memory')
          .select(
            'id, date, upload(uri, is_photo)',
          )
          .eq('user_id', userId)
          .order('id', ascending: true);
      result.addAll(items);
    } else if (albumID != null) {
      //
    } else if (hashtags.isNotEmpty) {
      final items = await supabase
          .from('memory')
          .select(
            'id, created_at, photo_uri, video_uri, date, hashtag(name)',
          )
          .eq('user_id', userId);

      for (final item in items) {
        if (item['hashtag'].isEmpty) {
          continue;
        }

        for (final hashtag in item['hashtag']) {
          if (hashtags.contains(hashtag['name'])) {
            result.add(item);
            break;
          }
        }
      }
    }

    return result.map((e) => MemoryListModel.fromJson(e)).toList();
  }

  /// 단일 조회
  /// - [userId] : 사용자 ID
  /// - [memoryId] : 기억 ID
  Future<MemoryModel?> retrieve({
    required String userId,
    required int memoryId,
  }) async {
    /**
     * TODO: 기억 단일 조회 기능 작성
     * - [x] memoryID로 기억 조회
     * - [ ] memory_hashtag에서 memoryID로 해시태그 목록 조회
     */
    final items = await supabase
        .from('memory')
        .select(
          'id, created_at, brand, photo_uri, video_uri, date, hashtag(name), memory_like(id)',
        )
        .eq('user_id', userId)
        .eq('id', memoryId);

    if (items.isNotEmpty) {
      final item = items.first;
      item['is_liked'] = item['memory_like'].isNotEmpty;
      return MemoryModel.fromJson(item);
    }

    return null;
  }

  /// 수정
  /// - [userId] : 사용자 ID
  /// - [memoryId] : 기억 ID
  /// - [photo] : 사진
  /// - [video] : 영상
  /// - [hashTags] : 해시태그 목록
  /// - [date] : 날짜
  edit({
    required String userId,
    required int memoryId,
    // required XFile? photo,
    // required XFile? video,
    // required List<String> hashtags,
    required DateTime date,
  }) async {
    /**
     * TODO: 기억 수정 기능 작성
     * - [x] memory 수정
     */

    try {
      await supabase
          .from('memory')
          .update({
            'date': date.toString(),
          })
          .eq('user_id', userId)
          .eq('id', memoryId);

      return true;
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.edit');
    }

    return false;
  }

  /// 삭제
  /// - [userId] : 사용자 ID
  /// - [memoryId] : 기억 ID
  Future<String?> delete({
    required String userId,
    required int memoryId,
  }) async {
    /**
     * TODO: 기억 삭제 기능 작성
     * - [x] memoryID로 기억 조회
     * - [x] memory 삭제
     * - [x] photo, video 삭제
     */
    final items = await supabase
        .from('memory')
        .select(
          'photo_uri, video_uri',
        )
        .eq('user_id', userId)
        .eq('id', memoryId);
    if (items.isEmpty) {
      return '기억을 찾을 수 없어요';
    }

    try {
      await supabase.from('memory').delete().eq('id', memoryId);

      final item = items.first;
      final photoUri = item['photo_uri'];
      final videoUri = item['video_uri'];

      final List<String> removeList = [];
      removeList.add('users/${photoUri.split('users/').last}');

      if (videoUri != null) {
        removeList.add('users/${videoUri.split('users/').last}');
      }

      await supabase.storage.from('picmory').remove(removeList);

      return null;
    } catch (error) {
      log(error.toString(), name: 'MemoryRepository.delete');
      return '기억을 삭제할 수 없어요';
    }
  }

  /// 앨범에 추가
  /// - [userId] : 사용자 Id
  /// - [memoryId] : 기억 Id
  /// - [albumId] : 앨범 Id
  Future<bool> addToAlbum({
    required String userId,
    required int memoryId,
    required List<int> albumIds,
  }) async {
    /**
     * TODO: 앨범에 기억 추가 기능 작성
     * - [x] memory_album 생성
     */
    try {
      await supabase.from('memory_album').insert(
            albumIds
                .map((albumId) => {
                      'memory_id': memoryId,
                      'album_id': albumId,
                    })
                .toList(),
          );

      return true;
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.addToAlbum');
      return false;
    }
  }

  /// 앨범에서 삭제
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  /// - [albumID] : 앨범 ID
  deleteFromAlbum({
    required String userID,
    required int memoryID,
    required int albumID,
  }) {
    /**
     * TODO: 앨범에서 기억 삭제 기능 작성
     * - [ ] memoryID & albumID로 memory_album 조회
     * - [ ] memory_album 삭제
     */
  }

  /// QR로 스캔한 URL 크롤링 API
  /// - [url] : URL
  Future<CrawledQrModel?> crawlUrl(String url) async {
    /**
     * TODO: 크롤링 API 호출 기능 작성
     */
    try {
      final res = await supabase.functions.invoke(
        'qr-crawler',
        body: {
          'url': url,
        },
      );

      return CrawledQrModel.fromJson(res.data);
    } on FunctionException catch (e) {
      log('${e.status.toString()} ${e.reasonPhrase}', name: 'MemoryRepository.crawlUrl');
      return null;
    }
  }

  /// 해시태그 목록 조회
  Future<List<String>> getHashtags({
    required String userId,
  }) async {
    final items = await supabase
        .from('memory')
        .select(
          'id, hashtag(name)',
        )
        .eq('user_id', userId);

    List<String> hashtags = [];
    for (final item in items) {
      if (item['hashtag'].isEmpty) {
        continue;
      }

      for (final hashtag in item['hashtag']) {
        if (!hashtags.contains(hashtag['name'])) {
          hashtags.add(hashtag['name']);
        }
      }
    }

    return hashtags;
  }

  /// 좋아요 상태 변경
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  Future<bool> changeLikeStatus({
    required String userId,
    required int memoryId,
    required bool isLiked,
  }) async {
    try {
      if (isLiked) {
        await supabase.from('memory_like').delete().eq('user_id', userId).eq('memory_id', memoryId);
      } else {
        await supabase.from('memory_like').insert({
          'user_id': userId,
          'memory_id': memoryId,
        });
      }
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.changeLikeStatus');
      return false;
    }

    return true;
  }
}
