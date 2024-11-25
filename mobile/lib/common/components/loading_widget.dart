import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/asset_image_token.dart';
import 'package:picmory/common/tokens/colors_token.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsToken.blackAlpha[400],
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: ColorsToken.white,
                shape: BoxShape.circle,
              ),
              child: ExtendedImage.asset(
                AssetImageToken.loadingBackground,
                fit: BoxFit.cover,
                scale: MediaQuery.of(context).devicePixelRatio + 1,
              ),
            ),
            ExtendedImage.asset(
              AssetImageToken.loading,
              fit: BoxFit.cover,
              scale: MediaQuery.of(context).devicePixelRatio + 1,
            ),
          ],
        ),
      ),
    );
  }
}
