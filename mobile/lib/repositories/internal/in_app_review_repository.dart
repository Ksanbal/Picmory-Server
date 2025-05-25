import 'dart:developer';
import 'dart:io';

import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InAppReviewRepository {
  final InAppReview inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    try {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      } else {
        // 스토어 링크로 이동
        if (Platform.isIOS) {
          await launchUrlString(
              "https://apps.apple.com/kr/app/picmory/id6476240673?action=write-review");
        } else if (Platform.isAndroid) {
          //
        }
      }
    } catch (e) {
      log('리뷰 요청 중 오류 발생: $e');
    }
  }
}
