import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/components/memory/retrieve/video_player.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solar_icons/solar_icons.dart';

class MemoryCreateView extends StatelessWidget {
  const MemoryCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryCreateViewmodel>(context, listen: false);
    vm.getDataFromExtra(context);

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: ColorFamily.backgroundGrey200,
            leading: IconButton(
              onPressed: context.pop,
              icon: const Icon(SolarIconsOutline.altArrowLeft),
            ),
            actions: [
              // 영상 추가 버튼
              Consumer<MemoryCreateViewmodel>(
                builder: (_, vm, __) {
                  if (vm.galleryVideos.isEmpty) {
                    return IconButton(
                      onPressed: vm.selectVideo,
                      icon: const Icon(SolarIconsOutline.videocameraAdd),
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Consumer<MemoryCreateViewmodel>(
                    builder: (_, vm, __) {
                      return Column(
                        children: [
                          Expanded(
                            child: PageView(
                              controller: vm.pageController,
                              children: vm.isFromQR
                                  ? [
                                      ...vm.crawledImageUrls.map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(9),
                                              child: ExtendedImage.network(
                                                e,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...vm.galleryVideos.map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: VideoPlayer(
                                            fromNetwork: true,
                                            uri: null,
                                            file: e,
                                          ),
                                        ),
                                      ),
                                    ]
                                  : [
                                      ...vm.galleryImages.map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(9),
                                              child: ExtendedImage.file(
                                                File(e.path),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...vm.galleryVideos.map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: VideoPlayer(
                                            fromNetwork: false,
                                            uri: null,
                                            file: e,
                                          ),
                                        ),
                                      ),
                                    ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 51,
                            ),
                            child: SmoothPageIndicator(
                              controller: vm.pageController,
                              count: (vm.isFromQR
                                      ? vm.crawledImageUrls.length
                                      : vm.galleryImages.length) +
                                  vm.galleryVideos.length,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                RoundedButton(
                  onPressed: () => vm.createMemory(context),
                  child: const Text(
                    "픽모리에 저장하기",
                    style: TextSmStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Consumer<MemoryCreateViewmodel>(
          builder: (_, vm, __) {
            if (vm.showLoading) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
