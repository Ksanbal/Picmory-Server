import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:shimmer/shimmer.dart';

Widget getShimmer(int index) {
  return SizedBox(
    height: [300.0, 200.0, 100.0][index % 3],
    child: Shimmer.fromColors(
      baseColor: ColorsToken.neutral[200]!,
      highlightColor: ColorsToken.neutral[300]!,
      child: Container(
        color: ColorsToken.white,
      ),
    ),
  );
}
