import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/families/asset_image_family.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ExtendedImage.asset(
                AssetImageFamily.loadingBackground,
                fit: BoxFit.cover,
                scale: MediaQuery.of(context).devicePixelRatio + 1,
              ),
            ),
            ExtendedImage.asset(
              AssetImageFamily.loading,
              fit: BoxFit.cover,
              scale: MediaQuery.of(context).devicePixelRatio + 1,
            ),
          ],
        ),
      ),
    );
  }
}
