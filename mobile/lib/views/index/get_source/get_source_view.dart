import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/common/buttons/icon_rounded_button.dart';
import 'package:picmory/common/families/asset_image_family.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_md_style.dart';
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
    vm.clearUrl();

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
        mainAxisSize: MainAxisSize.max,
        children: [
          // 스크롤 안내바
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: ColorFamily.disabledGrey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      "Scan QR Code",
                      style: TitleSmStyle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Paint your camera at the code",
                      style: TextSmStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                  ],
                ),
                // 카메라 영역
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 14),
                            child: Text(
                              "어드바이스 텍스트",
                              style: CaptionMdStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Point your camera at the code",
                      style: TextSmStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 갤러리에서 불러오기 버튼
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 215,
                      ),
                      child: IconRoundedButton(
                        onPressed: () => vm.getImageFromGallery(context),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        child: const Text(
                          "Button",
                          style: TextSmStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
