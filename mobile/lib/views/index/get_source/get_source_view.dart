import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picmory/viewmodels/index/index_viewmodel.dart';
import 'package:provider/provider.dart';

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
          // 카메라 영역
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              margin: const EdgeInsets.all(20),
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
          ),
          // 갤러리에서 불러오기 버튼
          TextButton(
            onPressed: () => vm.getImageFromGallery(context),
            child: const Text("갤러리에서 불러오기"),
          )
        ],
      ),
    );
  }
}
