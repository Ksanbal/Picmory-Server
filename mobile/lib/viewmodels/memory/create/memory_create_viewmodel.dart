import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picmory/main.dart';
import 'package:picmory/repositories/meory_repository.dart';

class MemoryCreateViewmodel extends ChangeNotifier {
  final MemoryRepository _memoryRepository = MemoryRepository();

  // 선택한 사진
  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  /// 갤러리에서 사진 불러오기
  getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    _selectedImage = image;
    notifyListeners();
  }

  // 선택한 동영상
  XFile? _selectedVideo;
  XFile? get selectedVideo => _selectedVideo;

  /// 갤러리에서 동영상 불러오기
  getVideoFromGallery() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    _selectedVideo = video;
    notifyListeners();
  }

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

  // 생성
  Future<void> createMemory(BuildContext context) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("사진을 선택해주세요."),
        ),
      );
      return;
    }

    await _memoryRepository
        .create(
      userId: supabase.auth.currentUser!.id,
      photo: _selectedImage!,
      video: _selectedVideo,
      hashtags: hashtags,
      date: date,
      brand: null,
    )
        .then((value) {
      if (value) {
        context.pop();
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
    });
  }
}
