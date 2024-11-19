import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/components/common/appbar_comp.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/components/memory/retrieve/video_player.dart';
import 'package:picmory/common/components/page_indicator_widget.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/main.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryCreateView extends StatelessWidget {
  const MemoryCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "memory create");

    final vm = Provider.of<MemoryCreateViewmodel>(context, listen: false);
    vm.getDataFromExtra(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Consumer<MemoryCreateViewmodel>(builder: (_, vm, __) {
              return AppBarComp(
                actions: [
                  if (vm.galleryVideos.isEmpty)
                    AppBarAction(
                      onPressed: vm.selectVideo,
                      icon: IconsToken().videocameraAddLinear,
                    )
                ],
              );
            }),
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
                                    (e) => Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          boxShadow: EffectsToken.shadow1,
                                          borderRadius: BorderRadius.circular(9),
                                        ),
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
                                    (e) => Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          boxShadow: EffectsToken.shadow1,
                                          borderRadius: BorderRadius.circular(9),
                                        ),
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
                        child: PageIndicatorWidget(
                          controller: vm.pageController,
                          count: vm.crawledImageUrls.length +
                              vm.galleryImages.length +
                              vm.galleryVideos.length,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            PrimaryButtonComp(
              onPressed: () => vm.createMemory(context),
              text: "픽모리에 저장하기",
            ),
          ],
        ),
      ),
    );
  }
}
