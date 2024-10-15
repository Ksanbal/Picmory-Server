import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picmory/common/utils/dio_service.dart';
import 'package:picmory/models/api/memory/create_memory_model.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/models/api/memory/upload_model.dart';
import 'package:picmory/models/response_model.dart';

class MemoriesRepository {
  final _dio = DioService().dio;

  static const path = '/memories';

  /// 파일 업로드
  ///
  /// [accessToken] 액세스 토큰
  /// [file] 파일
  Future<ResponseModel<UploadModel>> upload({
    required String accessToken,
    required XFile file,
  }) async {
    try {
      final res = await _dio.post(
        '$path/upload',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: file.name),
        }),
      );

      return ResponseModel<UploadModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: UploadModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400, 401, 403].contains(statusCode)) {
        return ResponseModel<UploadModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<UploadModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 추억 생성
  ///
  /// [accessToken] 액세스 토큰
  /// [fileIds] 파일 ID 목록
  /// [date] 날짜
  /// [brandName] 브랜드
  Future<ResponseModel<CreateMemoryModel>> create({
    required String accessToken,
    required List<int> fileIds,
    required DateTime date,
    required String brandName,
  }) async {
    try {
      final res = await _dio.post(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          'fileIds': fileIds,
          'date': date.toIso8601String(),
          'brandName': brandName,
        },
      );

      return ResponseModel<CreateMemoryModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: CreateMemoryModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400, 401, 403].contains(statusCode)) {
        return ResponseModel<CreateMemoryModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<CreateMemoryModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 추억 목록 조회
  ///
  /// [accessToken] 액세스 토큰
  /// [page] 페이지
  /// [limit] 개수
  /// [like] 좋아요 여부
  /// [albumId] 앨범 ID
  Future<ResponseModel<List<MemoryModel>>> list({
    required String accessToken,
    int page = 1,
    int limit = 20,
    bool? like,
    int? albumId,
  }) async {
    try {
      final res = await _dio.post(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
          'like': like,
          'albumId': albumId,
        },
      );

      return ResponseModel<List<MemoryModel>>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: (res.data as List).map((e) => MemoryModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403].contains(statusCode)) {
        return ResponseModel<List<MemoryModel>>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<List<MemoryModel>>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 추억 상세 조회
  ///
  /// [accessToken] 액세스 토큰
  /// [id] 추억 ID
  Future<ResponseModel<MemoryModel>> retrieve({
    required String accessToken,
    required int id,
  }) async {
    try {
      final res = await _dio.post(
        '$path/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return ResponseModel<MemoryModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: MemoryModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403, 404].contains(statusCode)) {
        return ResponseModel<MemoryModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<MemoryModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 추억 수정
  ///
  /// [accessToken] 액세스 토큰
  /// [id] 추억 ID
  /// [date] 날짜
  /// [brandName] 브랜드
  /// [like] 좋아요 여부
  Future<ResponseModel> edit({
    required String accessToken,
    required int id,
    required DateTime date,
    required String brandName,
    required bool like,
  }) async {
    try {
      final res = await _dio.put(
        '$path/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          'date': date.toIso8601String(),
          'brandName': brandName,
          'like': like,
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
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 추억 삭제
  ///
  /// [accessToken] 액세스 토큰
  /// [id] 추억 ID
  Future<ResponseModel> delete({
    required String accessToken,
    required int id,
    required DateTime date,
    required String brandName,
    required bool like,
  }) async {
    try {
      final res = await _dio.delete(
        '$path/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
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
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }
}
