import 'package:dio/dio.dart';
import 'package:picmory/common/utils/dio_service.dart';
import 'package:picmory/models/api/qr-crawler/brand_model.dart';
import 'package:picmory/models/api/qr-crawler/crawl_model.dart';
import 'package:picmory/models/response_model.dart';

class QrCrawlerRepository {
  final _dio = DioService().dio;

  static const path = '/qr-crawler';

  /// 지원하는 브랜드 목록 조회
  Future<ResponseModel<List<BrandModel>>> brandlist() async {
    try {
      final res = await _dio.get(
        '$path/brands',
      );

      return ResponseModel<List<BrandModel>>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: (res.data as List).map((e) => BrandModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ResponseModel<List<BrandModel>>(
        statusCode: e.response?.statusCode ?? 500,
        message: "알 수 없는 오류",
        data: null,
      );
    }
  }

  /// URL 크롤링
  ///
  /// [url] URL
  Future<ResponseModel<CrawlModel>> crawl({
    required String url,
  }) async {
    try {
      final res = await _dio.post(
        '$path/crawl-qr',
        data: {
          'url': url,
        },
      );

      return ResponseModel<CrawlModel>(
        statusCode: res.statusCode!,
        message: res.statusMessage!,
        data: CrawlModel.fromJson(res.data),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if ([400].contains(statusCode)) {
        return ResponseModel<CrawlModel>(
          statusCode: statusCode!,
          message: e.response?.data['message'],
          data: null,
        );
      } else {
        return ResponseModel<CrawlModel>(
          statusCode: e.response?.statusCode ?? 500,
          message: "알 수 없는 오류",
          data: null,
        );
      }
    }
  }
}
