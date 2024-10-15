import 'package:dio/dio.dart';
import 'package:picmory/common/utils/dio_service.dart';
import 'package:picmory/models/api/auth/access_token_model.dart';
import 'package:picmory/models/response_model.dart';

class AuthRepository {
  final _dio = DioService().dio;

  static const path = '/auth';

  /// 로그인
  ///
  /// [provider] 로그인 제공자 (apple, google)
  /// [providerId] 로그인 제공자 ID
  /// [fcmToken] FCM 토큰
  Future<ResponseModel<AccessTokenModel>> signin({
    required String provider,
    required String providerId,
    required String fcmToken,
  }) async {
    try {
      final res = await _dio.post(
        '$path/signin',
        data: {
          'provider': provider,
          'providerId': providerId,
          'fcmToken': fcmToken,
        },
      );

      return ResponseModel<AccessTokenModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: AccessTokenModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if ([404].contains(statusCode)) {
        return ResponseModel<AccessTokenModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<AccessTokenModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }

  /// 로그아웃
  ///
  /// [accessToken] 액세스 토큰
  Future<ResponseModel> signout({
    required String accessToken,
  }) async {
    try {
      final res = await _dio.post(
        '$path/signout',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      return ResponseModel(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: AccessTokenModel.fromJson(res.data),
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

  /// AccessToken 갱신
  ///
  /// [refreshToken] 리프레시 토큰
  Future<ResponseModel<AccessTokenModel>> refresh({
    required String refreshToken,
  }) async {
    try {
      final res = await _dio.post(
        '$path/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      return ResponseModel<AccessTokenModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: AccessTokenModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([401, 403].contains(statusCode)) {
        return ResponseModel<AccessTokenModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<AccessTokenModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }
}
