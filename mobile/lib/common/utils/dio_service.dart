import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:picmory/main.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  factory DioService() {
    return _instance;
  }

  DioService._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: remoteConfig.getString('api_host'),
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            sendTimeout: const Duration(milliseconds: 10000),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 헤더에 accessToken 추가
        final token = await _storage.read(key: 'accessToken');
        if (token != null) {
          options.headers.addAll({
            'Authorization': 'Bearer $token',
          });
        }

        log("${options.method} ${options.path} ${options.headers} ${options.data}", name: 'REQ');

        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('${response.requestOptions.method} ${response.requestOptions.path} ${response.statusCode}',
            name: 'RES');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        log('dio error', error: e, name: 'ERR');
        log(e.response.toString());

        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
