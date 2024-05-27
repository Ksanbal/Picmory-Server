import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/common/buttons/icon_rounded_button.dart';
import 'package:picmory/common/families/asset_image_family.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/viewmodels/index/index_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class GetSourceView extends StatelessWidget {
  const GetSourceView({
    super.key,
    required this.parentContext,
  });

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IndexViewmodel>(parentContext);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14,
        16,
        14,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 스크롤 안내바
          Container(
            width: 70,
            height: 4,
            margin: const EdgeInsets.only(bottom: 36),
            decoration: BoxDecoration(
              color: ColorFamily.disabledGrey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              "QR코드 한 번으로 간편하게",
              style: TitleSmStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              "픽모리와 함께라면 충분합니다",
              style: TextSmStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // 카메라 영역
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.normal,
                        facing: CameraFacing.back,
                      ),
                      onDetect: (capture) => vm.onQrDetact(
                        context,
                        parentContext,
                        capture,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      AssetImageFamily.cameraFilter,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 갤러리에서 불러오기 버튼
          Container(
            margin: const EdgeInsets.only(top: 36),
            child: IconRoundedButton(
              onPressed: () => vm.getImageFromGallery(context),
              backgroundColor: ColorFamily.primary,
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
          ),
        ],
      ),
    );
  }
}
