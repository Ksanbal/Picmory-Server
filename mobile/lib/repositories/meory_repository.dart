import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/hashtag/hashtag_create_model.dart';
import 'package:picmory/models/memory/crawled_qr_model.dart';
import 'package:picmory/models/memory/memory_create_model.dart';

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
    required List<String> hashtags,
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

      final data = await supabase
          .from('memory')
          .insert(
            newMemory.toJson(),
          )
          .select('id');
      final newMemoryId = data.first['id'];

      final hashtagIdList = [];
      for (final hashtag in hashtags) {
        final newHashtag = HashtagCreateModel(name: hashtag);
        final data = await supabase
            .from('hashtag')
            .upsert(
              newHashtag.toJson(),
              onConflict: "name",
            )
            .select('id');
        hashtagIdList.add(data.first['id']);
      }

      for (final hashtagId in hashtagIdList) {
        await supabase.from('memory_hashtag').insert({
          "memory_id": newMemoryId,
          "hashtag_id": hashtagId,
        });
      }

      return true;
    } catch (e) {
      log(e.toString(), name: 'MemoryRepository.create');
      return false;
    }
  }

  /// 목록 조회
  /// - [userID] : 사용자 ID
  /// - [albumID] : 앨범 ID
  /// - [hashtag] : 해시태그
  list({
    required String userID,
    required int? albumID,
    required String? hashtag,
  }) {
    /**
     * TODO: 기억 목록 조회 기능 작성
     * - [ ] albumID, hashtag가 모두 null이 아니면 에러
     * - [ ] albumID, hashtag가 모두 null이면 전체 기억 목록 조회
     * - [ ] albumID가 null이 아니면 해당 앨범의 기억 목록 조회
     * - [ ] hashtag가 null이 아니면 해당 해시태그가 포함된 기억 목록 조회
     */
  }

  /// 단일 조회
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  retrieve({
    required String userID,
    required int memoryID,
  }) {
    /**
     * TODO: 기억 단일 조회 기능 작성
     * - [ ] memoryID로 기억 조회
     * - [ ] memory_hashtag에서 memoryID로 해시태그 목록 조회
     */
  }

  /// 수정
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  /// - [photo] : 사진
  /// - [video] : 영상
  /// - [hashTags] : 해시태그 목록
  /// - [date] : 날짜
  edit({
    required String userID,
    required int memoryID,
    required XFile? photo,
    required XFile? video,
    required List<String> hashtags,
    required DateTime date,
  }) {
    /**
     * TODO: 기억 수정 기능 작성
     * - [ ] memoryID로 기억 조회
     * - [ ] albumID 유효성 체크
     * - [ ] hashtag 기존과 비교해서 사라진 해시태그는 삭제, 새로운 해시태그는 생성
     * - [ ] photo, video 삭제 & 업로드 & URI 획득
     * - [ ] memory 수정
     */
  }

  /// 삭제
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  delete({
    required String userID,
    required int memoryID,
  }) {
    /**
     * TODO: 기억 삭제 기능 작성
     * - [ ] memoryID로 기억 조회
     * - [ ] memory 삭제
     * - [ ] photo, video 삭제
     */
  }

  /// 앨범에 추가
  /// - [userID] : 사용자 ID
  /// - [memoryID] : 기억 ID
  /// - [albumID] : 앨범 ID
  addToAlbum({
    required String userID,
    required int memoryID,
    required int albumID,
  }) {
    /**
     * TODO: 앨범에 기억 추가 기능 작성
     * - [ ] memoryID로 기억 조회
     * - [ ] albumID로 앨범 조회
     * - [ ] memory_album 생성
     */
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
  /// - [jwt] : asdf
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
}
