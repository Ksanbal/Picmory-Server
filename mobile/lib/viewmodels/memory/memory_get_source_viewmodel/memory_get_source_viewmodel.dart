import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/common/components/memory/get_source/support_brands_bottomsheet.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/api/qr_crawler_repository.dart';
import 'package:picmory/repositories/memory_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MemoryGetSourceViewmodel extends ChangeNotifier {
  final MemoryRepository _memoryRepository = MemoryRepository();
  final QrCrawlerRepository _qrCrawlerRepository = QrCrawlerRepository();

  /// 지원브랜드 bottom sheet 열기
  openSupportBrandsBottomSheet(BuildContext context) async {
    final result = await _qrCrawlerRepository.brandlist();
    if (result.data == null) return;

    final brands = result.data!.map((e) => e.name).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (BuildContext _) {
        return SupportBrandsBottomsheet(brands);
      },
    );
  }

  /// 갤러리에서 사진 불러오기
  getImageFromGallery(BuildContext context) async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return;

    analytics.logEvent(name: 'load image from gallery');

    context.pushReplacement('/memory/create', extra: {
      'from': 'gallery',
      'image': [result],
      'video': [],
      'brand': null,
    });
  }

  /// QR 인식시
  String? _url;
  clearUrl() {
    _url = null;
  }

  onQrDetact(
    BuildContext context,
    // BuildContext parentContext,
    BarcodeCapture capture,
  ) async {
    if (_url != null) return;

    analytics.logEvent(name: 'load image from qr');

    final Barcode barcode = capture.barcodes.first;
    log('Barcode found! ${barcode.rawValue}');

    _url = barcode.rawValue;

    if (_url == null) return;

    context.pop();

    // api 호출로 이미지 & 영상 불러오기
    final result = await _memoryRepository.crawlUrl(_url!);
    if (result == null) {
      // 인웹으로 이동
      launchUrlString(_url!);
      return;
    }

    context.push(
      '/memory/create',
      extra: {
        'from': 'qr',
        'image': result.photo,
        'video': result.video,
        'brand': result.brand,
      },
    );
  }
}
