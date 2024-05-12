import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({
    super.key,
    required this.controller,
    required this.count,
  });

  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ExpandingDotsEffect(
        dotHeight: 6,
        dotWidth: 6,
        dotColor: ColorFamily.disabledGrey400,
      ),
    );
  }
}
