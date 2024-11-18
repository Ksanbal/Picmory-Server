import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:picmory/main.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  final Dio _dio;

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
      onRequest: (options, handler) {
        log("${options.method} ${options.path} ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('${response.requestOptions.method} ${response.requestOptions.path} ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        log('dio error', error: e);
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
