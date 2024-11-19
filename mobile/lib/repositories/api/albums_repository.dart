import 'package:dio/dio.dart';
import 'package:picmory/common/utils/dio_service.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/models/api/albums/create_album_model.dart';
import 'package:picmory/models/response_model.dart';

class AlbumsRepository {
  final _dio = DioService().dio;

  static const path = '/albums';

  /// 앨범 생성
  ///
  /// [name] 이름
  Future<ResponseModel<CreateAlbumModel>> create({
    required String name,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: {
          'name': name,
        },
      );

      return ResponseModel<CreateAlbumModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: CreateAlbumModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400, 401, 403].contains(statusCode)) {
        return ResponseModel<CreateAlbumModel>(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<CreateAlbumModel>(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 앨범 목록 조회
  ///
  /// [page] 페이지
  /// [limit] 개수
  Future<ResponseModel<List<AlbumModel>>> list({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _dio.get(
        path,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return ResponseModel<List<AlbumModel>>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: (res.data as List).map((e) => AlbumModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403].contains(statusCode)) {
        return ResponseModel<List<AlbumModel>>(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<List<AlbumModel>>(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 앨범 수정
  ///
  /// [id] 앨범 ID
  /// [name] 이름
  Future<ResponseModel> edit({
    required int id,
    required String name,
  }) async {
    try {
      final res = await _dio.put(
        '$path/$id',
        data: {
          'id': id,
          'name': name,
        },
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: null,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400, 401, 403, 404].contains(statusCode)) {
        return ResponseModel(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 앨범 삭제
  ///
  /// [id] 앨범 ID
  Future<ResponseModel> delete({
    required int id,
  }) async {
    try {
      final res = await _dio.delete(
        '$path/$id',
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: null,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403, 404].contains(statusCode)) {
        return ResponseModel(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 앨범에 추억 추가
  ///
  /// 앨범에 추억을 추가합니다. 이미 추가된 추억은 중복으로 추가되지 않습니다.
  ///
  /// [id] 앨범 ID
  /// [memoryId] 추억 ID
  Future<ResponseModel> addMemory({
    required int id,
    required int memoryId,
  }) async {
    try {
      final res = await _dio.post(
        '$path/$id/memories',
        data: {
          "memoryId": memoryId,
        },
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: null,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400, 401, 403, 404].contains(statusCode)) {
        return ResponseModel(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 앨범에서 추억 삭제
  ///
  /// [id] 앨범 ID
  /// [memoryId] 추억 ID
  Future<ResponseModel> deleteMemory({
    required int id,
    required int memoryId,
  }) async {
    try {
      final res = await _dio.post(
        '$path/$id/memories/$memoryId',
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: null,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403, 404].contains(statusCode)) {
        return ResponseModel(
          success: false,
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          success: false,
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }
}
