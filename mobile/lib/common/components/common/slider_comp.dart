import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderComp extends StatelessWidget {
  const SliderComp({
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
      effect: ExpandingDotsEffect(
        dotHeight: 6,
        dotWidth: 6,
        dotColor: ColorsToken.neutral[400]!,
        activeDotColor: ColorsToken.primary,
        spacing: 6,
        radius: 3,
        expansionFactor: 3,
      ),
    );
  }
}
