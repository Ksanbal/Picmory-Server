import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picmory/common/utils/show_loading.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/meory_repository.dart';

class MemoryCreateViewmodel extends ChangeNotifier {
  // Singleton instance
  static final MemoryCreateViewmodel _singleton = MemoryCreateViewmodel._internal();

  // Factory method to return the same instance
  factory MemoryCreateViewmodel() {
    return _singleton;
  }

  // Named constructor
  MemoryCreateViewmodel._internal();

  final MemoryRepository _memoryRepository = MemoryRepository();

  bool _createComplete = false;
  bool get createComplete => _createComplete;

  PageController pageController = PageController(
    viewportFraction: 0.9,
  );

  // QR 스캔 여부
  bool _isFromQR = false;
  bool get isFromQR => _isFromQR;

  /// QR로 가져온 사진 URL
  List<String> _crawledImageUrls = [];
  List<String> get crawledImageUrls => _crawledImageUrls;

  /// QR로 가져온 브랜드
  String? _crawledBrand;
  String? get crawledBrand => _crawledBrand;

  // 선택한 사진
  List<XFile> _galleryImages = [];
  List<XFile> get galleryImages => _galleryImages;

  // 선택한 동영상
  List<XFile> _galleryVideos = [];
  List<XFile> get galleryVideos => _galleryVideos;

  /// 날짜
  DateTime date = DateTime.now();
  showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        color: Colors.white,
        child: CupertinoDatePicker(
          initialDateTime: date,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (value) {
            date = value;
            notifyListeners();
          },
        ),
      ),
    );
  }

  // 해시태그
  TextEditingController hashtagController = TextEditingController();
  List<String> hashtags = [];

  /// 소스 선택 페이지에서 가져온 데이터 처리
  getDataFromExtra(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

      if (extra == null) return;
      final from = extra['from'];

      if (from == 'gallery') {
        _galleryImages = extra['image'].map<XFile>((e) => e as XFile).toList();
        _galleryVideos = extra['video'].map<XFile>((e) => e as XFile).toList();
      } else if (from == 'qr') {
        _isFromQR = true;
        _crawledImageUrls = extra['image'];
        for (final url in extra['video']) {
          final tempVideoPath = await getTemporaryDirectory();
          final savedVideoPath = "${tempVideoPath.path}/${DateTime.now().second}.mp4";

          await Dio().download(
            url,
            savedVideoPath,
          );
          _galleryVideos = [XFile(savedVideoPath)];
        }
        _crawledBrand = extra['brand'];
      }

      notifyListeners();
    });
  }

  hastagOnCSumbitted(String value) {
    if (!hashtags.contains(value)) {
      hashtags.add(value);
    }
    hashtagController.clear();

    notifyListeners();
  }

  removeFromHashtags(String value) {
    hashtags.remove(value);

    notifyListeners();
  }

  /// 영상 선택 호출
  void selectVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      _galleryVideos.add(video);
      notifyListeners();
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // 생성
  Future<void> createMemory(BuildContext context) async {
    // 로딩 표시
    showLoading(context);

    if (_isFromQR) {
      if (_crawledImageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("QR에서 데이터를 가져오지 못했습니다."),
          ),
        );
        return;
      }
    } else {
      if (_galleryImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("사진을 선택해주세요."),
          ),
        );
        return;
      }
    }

    // QR에서 가져온 경우 이미지, 영상을 다운로드 받아서 갤러리에 저장, 저장된 파일을 업로드
    int? newMemoryId;

    if (_isFromQR) {
      try {
        Dio dio = Dio();

        // 사진 다운로드
        final List<File> downloadedImageFiles = [];
        for (final url in _crawledImageUrls) {
          final response = await dio.get(
            url,
            options: Options(responseType: ResponseType.bytes),
          );

          // 갤러리에 사진 다운로드
          final photoResult = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 100,
            isReturnImagePathOfIOS: true,
          );

          final tempPhotoPath = await getTemporaryDirectory();
          final imageFile = await File(
            '${tempPhotoPath.path}/${photoResult['filePath'].split("/").last}',
          ).writeAsBytes(response.data);

          downloadedImageFiles.add(imageFile);
        }

        // 영상 다운로드
        for (final file in _galleryVideos) {
          // 갤러리에 영상 다운로드
          await ImageGallerySaver.saveFile(
            file.path,
          );
        }

        newMemoryId = await _memoryRepository.create(
          userId: supabase.auth.currentUser!.id,
          photoList: downloadedImageFiles,
          photoNameList: downloadedImageFiles.map((e) => e.path.split('/').last).toList(),
          videoList: _galleryVideos.map((e) => File(e.path)).toList(),
          videoNameList: _galleryVideos.map((e) => e.name).toList(),
          date: date,
          brand: _crawledBrand,
        );
      } catch (e) {
        log(e.toString());
        return;
      }
    } else {
      newMemoryId = await _memoryRepository.create(
        userId: supabase.auth.currentUser!.id,
        photoList: _galleryImages.map((e) => File(e.path)).toList(),
        photoNameList: _galleryImages.map((e) => e.name).toList(),
        videoList: _galleryVideos.map((e) => File(e.path)).toList(),
        videoNameList: _galleryVideos.map((e) => e.name).toList(),
        date: date,
        brand: null,
      );
    }

    // 로딩 표시
    removeLoading();

    analytics.logEvent(name: 'create memory', parameters: {
      'from': _isFromQR ? 'qr' : 'gallery',
      'brand': crawledBrand ?? '',
    });

    if (newMemoryId != null) {
      _createComplete = true;

      context.pushReplacement('/memory/$newMemoryId');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("기억이 생성되었습니다 🎉"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("생성에 실패했습니다 😢"),
        ),
      );
    }
  }
}
