import 'package:image_picker/image_picker.dart';

/// 기억 관련 서버 통신을 담당하는 클래스
class MemoryRemoteDatasourece {
  /// 기억 생성
  /// - [userID] : 사용자 ID
  /// - [photo] : 사진
  /// - [video] : 영상
  /// - [hashTags] : 해시태그 목록
  /// - [date] : 날짜
  /// - [brand] : 브랜드
  Future<bool> create({
    required String userID,
    required XFile photo,
    required XFile? video,
    required List<String> hashtags,
    required DateTime date,
    required String? brand,
  }) async {
    /** 
     * TODO: 기억 생성 기능 작성
     * - [ ] photo, video 업로드 & URI 획득
     * - [ ] memory 생성
     * - [ ] hashtags 목록에서 DB에 없는 해시태그는 생성
     * - [ ] memory_hashtag 생성
     */
    return false;
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
}
