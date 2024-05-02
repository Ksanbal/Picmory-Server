import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/components/memory/retrieve/video_player.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryCreateView extends StatelessWidget {
  const MemoryCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryCreateViewmodel>(context, listen: false);
    vm.getDataFromExtra(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              // 영상 추가 버튼
              Consumer<MemoryCreateViewmodel>(
                builder: (_, vm, __) {
                  if (vm.galleryVideos.isEmpty) {
                    return TextButton(
                      onPressed: vm.selectVideo,
                      child: const Text("영상 추가"),
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
                      return PageView(
                        controller: vm.pageController,
                        children: vm.isFromQR
                            ? []
                            : [
                                ...vm.galleryImages.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: ExtendedImage.file(
                                      File(e.path),
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
                      );
                    },
                  ),
                ),
                RoundedButton(
                  onPressed: () => vm.createMemory(context),
                  child: const Text("픽모리에 저장하기"),
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
