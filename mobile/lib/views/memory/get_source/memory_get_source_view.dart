import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/common/buttons/icon_rounded_button.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_md_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/viewmodels/memory/memory_get_source_viewmodel/memory_get_source_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class MemoryGetSourceView extends StatelessWidget {
  const MemoryGetSourceView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryGetSourceViewmodel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: context.pop,
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              SolarIconsOutline.altArrowLeft,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 카메라 영역
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
                facing: CameraFacing.back,
              ),
              onDetect: (capture) => vm.onQrDetact(
                context,
                // parentContext,
                capture,
              ),
            ),
          ),
          // 반투명 배경
          ClipPath(
            clipper: HoleClipper(),
            child: Container(
              color: ColorFamily.textGrey900.withOpacity(0.8),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "QR 스캔",
                        style: TitleSmStyle(
                          color: ColorFamily.backgroundGrey100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "QR인식을 통하여 빠르게 사진 가져오기",
                          style: TextSmStyle(
                            color: ColorFamily.disabledGrey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 빈공간 영역
              SizedBox(height: MediaQuery.of(context).size.width - 17 - 17),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 갤러리에서 불러오기 버튼
                    IconRoundedButton(
                      onPressed: () => vm.getImageFromGallery(context),
                      backgroundColor: ColorFamily.primary,
                      isDense: true,
                      icon: const Icon(
                        SolarIconsBold.album,
                        color: Colors.white,
                      ),
                      child: const Text(
                        "앨범에서 사진 불러오기",
                        style: TextSmStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // 서비스 브랜드
                    Padding(
                      padding: const EdgeInsets.only(top: 19.41),
                      child: InkWell(
                        onTap: () => vm.openSupportBrandsBottomSheet(context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                SolarIconsOutline.dangerCircle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Text(
                              "서비스 브랜드",
                              style: CaptionMdStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 사용자 정의 클리퍼 클래스
class HoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    path.addRect(rect);

    // 중앙 사각형의 크기를 계산 (1:1 비율 유지)
    var minSide = min(size.width, size.height);
    var squareSize = minSide - 17 - 17; // 중앙 사각형의 크기를 전체의 50%로 설정

    // 중앙 사각형의 좌표를 계산
    var left = (size.width - squareSize) / 2;
    var top = (size.height - squareSize) / 2;
    var holeRect = Rect.fromLTWH(left, top, squareSize, squareSize);
    // 모서리에 radius 추가
    var holeRRect = RRect.fromRectAndRadius(holeRect, const Radius.circular(5));
    path.addRRect(holeRRect);

    path.fillType = PathFillType.evenOdd; // 내부 경로를 제외시킴

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
