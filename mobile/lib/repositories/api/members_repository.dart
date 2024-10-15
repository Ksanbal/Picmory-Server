import 'package:dio/dio.dart';
import 'package:picmory/common/utils/dio_service.dart';
import 'package:picmory/models/api/members/member_model.dart';
import 'package:picmory/models/response_model.dart';

class MembersRepository {
  final _dio = DioService().dio;

  static const path = '/members';

  /// 회원가입
  ///
  /// [provider] 로그인 제공자 (apple, google)
  /// [providerId] 로그인 제공자 ID
  /// [email] 이메일
  /// [name] 이름
  /// [metadata] 메타데이터
  Future<ResponseModel> signup({
    required String provider,
    required String providerId,
    required String email,
    required String name,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: {
          'provider': provider,
          'providerId': providerId,
          'email': email,
          'name': name,
          'metadata': metadata,
        },
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: null,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400].contains(statusCode)) {
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

  /// 내 정보 조회
  ///
  /// [accessToken] 액세스 토큰
  Future<ResponseModel<MemberModel>> getMe({
    required String accessToken,
  }) async {
    try {
      final res = await _dio.get(
        '$path/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return ResponseModel<MemberModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: MemberModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403, 404].contains(statusCode)) {
        return ResponseModel<MemberModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<MemberModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 회원탈퇴
  ///
  /// [accessToken] 액세스 토큰
  Future<ResponseModel> deleteMe({
    required String accessToken,
  }) async {
    try {
      final res = await _dio.delete(
        '$path/me',
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
