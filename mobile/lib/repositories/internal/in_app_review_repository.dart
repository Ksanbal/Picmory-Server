import 'dart:developer';

import 'package:in_app_review/in_app_review.dart';

class InAppReviewRepository {
  final InAppReview inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    try {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    } catch (e) {
      log('리뷰 요청 중 오류 발생: $e');
    }
  }
}
