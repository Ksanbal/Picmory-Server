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
  /// [file] 파일
  Future<ResponseModel<UploadModel>> upload({
    required XFile file,
  }) async {
    try {
      final res = await _dio.post(
        '$path/upload',
        options: Options(
          headers: {
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
  /// [fileIds] 파일 ID 목록
  /// [date] 날짜
  /// [brandName] 브랜드
  Future<ResponseModel<CreateMemoryModel>> create({
    required List<int> fileIds,
    required DateTime date,
    required String brandName,
  }) async {
    try {
      final res = await _dio.post(
        path,
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
  /// [page] 페이지
  /// [limit] 개수
  /// [like] 좋아요 여부
  /// [albumId] 앨범 ID
  Future<ResponseModel<List<MemoryModel>>> list({
    int page = 1,
    int limit = 20,
    bool? like,
    int? albumId,
  }) async {
    try {
      final res = await _dio.get(
        path,
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
  /// [id] 추억 ID
  Future<ResponseModel<MemoryModel>> retrieve({
    required int id,
  }) async {
    try {
      final res = await _dio.get(
        '$path/$id',
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
  /// [id] 추억 ID
  /// [date] 날짜
  /// [brandName] 브랜드
  /// [like] 좋아요 여부
  Future<ResponseModel> edit({
    required int id,
    required DateTime date,
    required String brandName,
    required bool like,
  }) async {
    try {
      final res = await _dio.put(
        '$path/$id',
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
  /// [id] 추억 ID
  Future<ResponseModel> delete({
    required int id,
    required DateTime date,
    required String brandName,
    required bool like,
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
