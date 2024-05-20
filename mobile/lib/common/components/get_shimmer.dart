import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:shimmer/shimmer.dart';

Widget getShimmer(int index) {
  return SizedBox(
    height: [300.0, 200.0, 100.0][index % 3],
    child: Shimmer.fromColors(
      baseColor: ColorFamily.disabledGrey400,
      highlightColor: ColorFamily.disabledGrey300,
      child: Container(
        color: Colors.white,
      ),
    ),
  );
}
