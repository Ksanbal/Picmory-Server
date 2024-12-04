import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/components/common/slider_comp.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/tokens/asset_image_token.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/common/utils/get_storage_uri.dart';
import 'package:picmory/common/utils/get_thumbnail_uri.dart';
import 'package:picmory/main.dart';
import 'package:picmory/viewmodels/index/for_you/for_you_viewmodel.dart';
import 'package:provider/provider.dart';

class ForYouView extends StatefulWidget {
  const ForYouView({super.key});

  @override
  State<ForYouView> createState() => _ForYouViewState();
}

class _ForYouViewState extends State<ForYouView> {
  late final vm = Provider.of<ForYouViewmodel>(context, listen: false);

  @override
  void initState() {
    analytics.logScreenView(screenName: "for you");
    vm.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForYouViewmodel>(
      builder: (_, vm, __) {
        return Stack(
          children: [
            vm.memories == null && vm.albums == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImageToken.emptyForYou,
                        ),
                        Gap(SizeToken.m),
                        Text(
                          "아직 좋아하는\n추억이 없어요",
                          textAlign: TextAlign.center,
                          style: TypographyToken.titleSm.copyWith(
                            color: ColorsToken.neutral[900],
                          ),
                        ),
                        Gap(SizeToken.m),
                        Text(
                          "좋아하는 순간들을\n추억함에 담아두세요",
                          textAlign: TextAlign.center,
                          style: TypographyToken.textSm.copyWith(
                            color: ColorsToken.neutral[400],
                          ),
                        ),
                        Gap(SizeToken.xxl),
                      ],
                    ),
                  )
                : ListView(
                    controller: vm.forYouViewController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 64 + MediaQuery.of(context).padding.top,
                      bottom: MediaQuery.of(context).padding.bottom + 110,
                    ),
                    children: [
                      // 좋아요
                      if (!(vm.memories == null || (vm.memories ?? []).isEmpty))
                        SizedBox(
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
                                          getThumbnailUri(memory.files),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          loadStateChanged: (state) {
                                            if (state.extendedImageLoadState == LoadState.loading) {
                                              return getShimmer(index);
                                            }
                                            if (state.extendedImageLoadState == LoadState.failed) {
                                              return Center(
                                                child: IconsToken().dangerCircleBold,
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
                              SliderComp(
                                controller: vm.likePageController,
                                count: (vm.memories ?? []).length,
                              ),
                              InkWell(
                                onTap: () => vm.routeToLikeMemories(context),
                                child: Row(
                                  children: [
                                    Text(
                                      "좋아요 더보기",
                                      style: TypographyToken.textSm.copyWith(
                                        color: ColorsToken.neutral[600],
                                      ),
                                    ),
                                    IconsToken(
                                      color: ColorsToken.neutral[600]!,
                                      size: IconTokenSize.small,
                                    ).altArrowRightLinear
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      // 앨범
                      if (vm.albums != null)
                        GridView.builder(
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
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: getShimmer(index),
                                    ),
                                  ),
                                  Gap(SizeToken.xxs),
                                  Text(
                                    "-",
                                    style: TypographyToken.textSm.copyWith(
                                      color: ColorsToken.neutral[950],
                                    ),
                                  ),
                                  Text(
                                    "-",
                                    style: TypographyToken.captionSm.copyWith(
                                      color: ColorsToken.neutral[500],
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
                                      onTap: () => vm.routeToAlbums(context, index),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: album.coverImagePath == null
                                            ? Container(
                                                color: ColorsToken.neutral[200]!,
                                              )
                                            : ExtendedImage.network(
                                                getStorageUri(album.coverImagePath!),
                                                fit: BoxFit.cover,
                                                loadStateChanged: (state) {
                                                  if (state.extendedImageLoadState ==
                                                      LoadState.loading) {
                                                    return getShimmer(index);
                                                  }
                                                  if (state.extendedImageLoadState ==
                                                      LoadState.failed) {
                                                    return Center(
                                                      child: IconsToken().dangerCircleBold,
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
                                  style: TypographyToken.textSm.copyWith(
                                    color: ColorsToken.neutral[950],
                                  ),
                                ),
                                Text(
                                  album.memoryCount.toString(),
                                  style: TypographyToken.captionSm.copyWith(
                                    color: ColorsToken.neutral[500],
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
                      ColorsToken.blackAlpha[400]!,
                      ColorsToken.black.withOpacity(0),
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
                    IconButtonComp(
                      onPressed: () => vm.createAlbum(context),
                      icon: IconsToken(
                        size: IconTokenSize.small,
                        color: vm.isShrink ? ColorsToken.white : ColorsToken.black,
                      ).addFolderLinear,
                      backgroundColor:
                          vm.isShrink ? ColorsToken.neutralAlpha[500]! : Colors.transparent,
                    ),
                    Gap(SizeToken.s),
                    IconButtonComp(
                      onPressed: () => vm.routeToMenu(context),
                      icon: IconsToken(
                        size: IconTokenSize.small,
                        color: vm.isShrink ? ColorsToken.white : ColorsToken.black,
                      ).hamburgerMenuLinear,
                      backgroundColor:
                          vm.isShrink ? ColorsToken.neutralAlpha[500]! : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
