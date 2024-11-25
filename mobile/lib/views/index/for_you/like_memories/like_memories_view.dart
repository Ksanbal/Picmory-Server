import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/utils/get_thumbnail_uri.dart';
import 'package:picmory/viewmodels/index/for_you/like_memories/like_memories_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class LikeMemoriesView extends StatelessWidget {
  const LikeMemoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LikeMemoriesViewmodel>(
        builder: (_, vm, __) {
          return Stack(
            children: [
              ListView.separated(
                controller: vm.scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + kToolbarHeight,
                  16,
                  MediaQuery.of(context).padding.bottom,
                ),
                itemCount: vm.memories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (_, index) {
                  final memory = vm.memories[index];

                  return InkWell(
                    onTap: () => vm.goToMemoryRetrieve(context, memory),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: ExtendedImage.network(
                            getThumbnailUri(memory.files),
                            fit: BoxFit.cover,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState == LoadState.loading) {
                                return getShimmer(index);
                              }
                              if (state.extendedImageLoadState == LoadState.failed) {
                                return const Center(
                                  child: Icon(Icons.error),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => vm.unlikeMemory(memory),
                            padding: const EdgeInsets.all(16),
                            icon: const Icon(
                              SolarIconsBold.heart,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (vm.isShrink)
                Container(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundColor:
                        vm.isShrink ? Colors.black.withOpacity(0.3) : Colors.transparent,
                    child: IconButton(
                      icon: const Icon(
                        SolarIconsOutline.altArrowLeft,
                      ),
                      color: vm.isShrink ? Colors.white : Colors.black,
                      onPressed: context.pop,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
