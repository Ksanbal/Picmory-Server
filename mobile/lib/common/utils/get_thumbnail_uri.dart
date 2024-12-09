import 'package:picmory/common/utils/get_storage_uri.dart';
import 'package:picmory/models/api/memory/memory_model.dart';

String getThumbnailUri(List<MemoryFileModel> memoryFiles) {
  // 이미지 게시물이 있으면 이미지 게시물을 반환
  // 영상이 있으면 영상 게시물을 반환
  for (final file in memoryFiles) {
    if (file.type == 'IMAGE') {
      return getStorageUri(file.thumbnailPath ?? file.path);
    }
  }

  for (final file in memoryFiles) {
    if (file.type == 'VIDEO') {
      return getStorageUri(file.thumbnailPath ?? file.path);
    }
  }

  return '';
}
