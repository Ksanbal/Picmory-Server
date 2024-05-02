import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/repositories/meory_repository.dart';
import 'package:picmory/views/index/get_source/get_source_view.dart';

class IndexViewmodel extends ChangeNotifier {
  final MemoryRepository _memoryRepository = MemoryRepository();

  /// 하단 바텀 네비게이션의 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// 하단 바텀 네비게이션의 인덱스 변경
  bottomNavigationHandler(BuildContext context, int value) {
    if (value == 1) {
      _showQrModalBottomSheet(context);
    } else {
      _currentIndex = value;
      notifyListeners();
    }
  }

  /// QR 인식 모달 노출
  _showQrModalBottomSheet(BuildContext context) async {
    // QR코드 modal 노출
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) {
        return GetSourceView(
          parentContext: context,
        );
      },
    );
  }

  /// 갤러리에서 사진 불러오기
  getImageFromGallery(BuildContext context) async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return;

    context.pop();
    context.push('/memory/create', extra: {
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
    BuildContext parentContext,
    BarcodeCapture capture,
  ) async {
    if (_url != null) return;

    final Barcode barcode = capture.barcodes.first;
    log('Barcode found! ${barcode.rawValue}');

    _url = barcode.rawValue;

    context.pop();

    // api 호출로 이미지 & 영상 불러오기
    final result = await _memoryRepository.crawlUrl(_url!);
    if (result == null) return;

    parentContext.push(
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
