import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/components/page_indicator_widget.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/viewmodels/index/for_you/for_you_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForYouViewmodel>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: vm.forYouViewController,
            padding: EdgeInsets.only(
              top: 64 + MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom + 110,
            ),
            children: [
              vm.memories == null || (vm.memories ?? []).isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Text("하트를 누른 사진들을 보여드릴게요!"),
                      ),
                    )
                  // 좋아요
                  : SizedBox(
                      height: MediaQuery.of(context).size.width - 32,
                      child: PageView.builder(
                        itemCount: vm.memories?.length,
                        controller: vm.likePageController,
                        itemBuilder: (context, index) {
                          final memory = (vm.memories ?? [])[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: InkWell(
                                  onTap: () => vm.goToMemoryRetrieve(context, memory),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: ExtendedImage.network(
                                      memory.photoUri,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
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
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              if ((vm.memories ?? []).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PageIndicatorWidget(
                        controller: vm.likePageController,
                        count: (vm.memories ?? []).length,
                      ),
                      InkWell(
                        onTap: () => vm.routeToLikeMemories(context),
                        child: const Row(
                          children: [
                            Text(
                              "좋아요 더보기",
                              style: TextSmStyle(
                                color: ColorFamily.textGrey600,
                              ),
                            ),
                            Icon(
                              SolarIconsOutline.altArrowRight,
                              color: ColorFamily.textGrey600,
                              size: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              // 앨범
              vm.albums == null
                  ? const Center(
                      child: Text("앨범을 만들어서 추억을 관리해보세요!"),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 16,
                        childAspectRatio: 160 / 206,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: (vm.albums ?? []).isEmpty ? 10 : (vm.albums ?? []).length,
                      itemBuilder: (context, index) {
                        if ((vm.albums ?? []).isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: getShimmer(index),
                                  ),
                                ),
                              ),
                              const Text(
                                "-",
                                style: TextSmStyle(),
                              ),
                              const Text(
                                "-",
                                style: CaptionSmStyle(
                                  color: ColorFamily.disabledGrey500,
                                ),
                              )
                            ],
                          );
                        }

                        final album = (vm.albums ?? [])[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: InkWell(
                                  onTap: () => vm.routeToAlbums(context, album.id),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: album.imageUrls.isEmpty
                                        ? Container(
                                            color: ColorFamily.disabledGrey400,
                                          )
                                        : ExtendedImage.network(
                                            album.imageUrls.first,
                                            fit: BoxFit.cover,
                                            loadStateChanged: (state) {
                                              if (state.extendedImageLoadState ==
                                                  LoadState.loading) {
                                                return getShimmer(index);
                                              }
                                              if (state.extendedImageLoadState ==
                                                  LoadState.failed) {
                                                return const Center(
                                                  child: Icon(Icons.error),
                                                );
                                              }
                                              return null;
                                            },
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              album.name,
                              style: const TextSmStyle(),
                            ),
                            Text(
                              album.imageUrls.length.toString(),
                              style: const CaptionSmStyle(
                                color: ColorFamily.disabledGrey500,
                              ),
                            )
                          ],
                        );
                      },
                    ),
            ],
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
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        vm.isShrink ? Colors.black.withOpacity(0.3) : Colors.transparent,
                    child: IconButton(
                      icon: const Icon(SolarIconsOutline.addFolder),
                      color: vm.isShrink ? Colors.white : Colors.black,
                      onPressed: () => vm.createAlbum(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor:
                        vm.isShrink ? Colors.black.withOpacity(0.3) : Colors.transparent,
                    child: IconButton(
                      icon: const Icon(SolarIconsOutline.hamburgerMenu),
                      color: vm.isShrink ? Colors.white : Colors.black,
                      onPressed: () => vm.routeToMenu(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
