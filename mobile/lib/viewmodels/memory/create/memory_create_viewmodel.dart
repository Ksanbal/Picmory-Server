import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  bool _showLoading = false;
  bool get showLoading => _showLoading;

  PageController pageController = PageController(
    viewportFraction: 0.9,
  );

  // QR 스캔 여부
  bool _isFromQR = false;
  bool get isFromQR => _isFromQR;

  /// QR로 가져온 사진 URL
  List<String> _crawledImageUrls = [];
  List<String> get crawledImageUrls => _crawledImageUrls;

  /// QR로 가져온 동영상 URL
  List<String> _crawledVideoUrls = [];
  List<String> get crawledVideoUrls => _crawledVideoUrls;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

      if (extra == null) return;
      final from = extra['from'];

      if (from == 'gallery') {
        _galleryImages = extra['image'].map<XFile>((e) => e as XFile).toList();
        _galleryVideos = extra['video'].map<XFile>((e) => e as XFile).toList();
      } else if (from == 'qr') {
        _isFromQR = true;
        _crawledImageUrls = extra['image'];
        _crawledVideoUrls = extra['video'];
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
    _showLoading = true;
    notifyListeners();

    if (_isFromQR) {
      if (_crawledImageUrls.isEmpty || _crawledVideoUrls.isEmpty) {
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
    // bool result = false;
    int? newMemoryId;

    if (_isFromQR) {
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
    _showLoading = false;
    notifyListeners();

    if (newMemoryId != null) {
      // final homeViewmodel = Provider.of<HomeViewmodel>(context, listen: false);
      // homeViewmodel.clearDatas();
      // homeViewmodel.loadMemories();

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

    // // QR에서 가져온 경우 이미지, 영상을 다운로드 받아서 갤러리에 저장, 저장된 파일을 업로드
    // bool result = false;
    // if (_isFromQR) {
    //   try {
    //     Dio dio = Dio();

    //     // 사진 다운로드
    //     for (final url in _crawledImageUrls) {
    //       final response = await dio.get(
    //         url,
    //         options: Options(responseType: ResponseType.bytes),
    //       );

    //       // 갤러리에 사진 다운로드
    //       final photoResult = await ImageGallerySaver.saveImage(
    //         Uint8List.fromList(response.data),
    //         quality: 100,
    //         isReturnImagePathOfIOS: true,
    //       );
    //     }

    //     // 영상 다운로드
    //     for (final url in _crawledVideoUrls) {
    //       final tempVideoPath = await getTemporaryDirectory();
    //       final videoFilename = url.split("/").last.split("?").first;
    //       final savedVideoPath = "${tempVideoPath.path}/$videoFilename";
    //       await dio.download(
    //         url,
    //         savedVideoPath,
    //       );

    //       // 갤러리에 영상 다운로드
    //       await ImageGallerySaver.saveFile(
    //         savedVideoPath,
    //       );
    //     }

    //     final tempPhotoPath = await getTemporaryDirectory();

    //     result = await _memoryRepository.create(
    //       userId: supabase.auth.currentUser!.id,
    //       photo: await File(
    //         '${tempPhotoPath.path}/${photoResult['filePath'].split("/").last}',
    //       ).writeAsBytes(response.data),
    //       photoName: photoResult['filePath'].split("/").last,
    //       video: File(savedVideoPath),
    //       videoName: videoFilename,
    //       date: date,
    //       brand: null,
    //     );
    //   } catch (e) {
    //     log(e.toString());
    //     return;
    //   }
    // } else {
    //   result = await _memoryRepository.create(
    //     userId: supabase.auth.currentUser!.id,
    //     photo: File(_galleryImages!.path),
    //     photoName: _galleryImages!.name,
    //     video: _galleryVideos != null ? File(_galleryVideos!.path) : null,
    //     videoName: _galleryVideos?.name,
    //     date: date,
    //     brand: null,
    //   );
    // }

    // if (result) {
    //   // final homeViewmodel = Provider.of<HomeViewmodel>(context, listen: false);
    //   // homeViewmodel.clearDatas();
    //   // homeViewmodel.loadMemories();

    //   _createComplete = true;

    //   context.pop();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("기억이 생성되었습니다 🎉"),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("생성에 실패했습니다 😢"),
    //     ),
    //   );
    // }
  }
}
