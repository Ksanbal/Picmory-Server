import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/tokens/asset_image_token.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/common/utils/get_thumbnail_uri.dart';
import 'package:picmory/models/api/albums/album_model.dart';
import 'package:picmory/viewmodels/index/for_you/albums/albums_viewmodel.dart';
import 'package:provider/provider.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    AlbumsViewmodel vm = Provider.of<AlbumsViewmodel>(context, listen: false);
    vm.album = GoRouterState.of(context).extra as AlbumModel;

    return Scaffold(
      body: Consumer<AlbumsViewmodel>(
        builder: (_, vm, __) {
          return Stack(
            children: [
              vm.memories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetImageToken.emptyAlbum,
                          ),
                          Gap(SizeToken.m),
                          Text(
                            "아직 저장된\n추억이 없어요",
                            textAlign: TextAlign.center,
                            style: TypographyToken.titleSm.copyWith(
                              color: ColorsToken.neutral[900],
                            ),
                          ),
                          Gap(SizeToken.m),
                          Text(
                            "소중한 순간들을\n추억함에 담아두세요",
                            textAlign: TextAlign.center,
                            style: TypographyToken.textSm.copyWith(
                              color: ColorsToken.neutral[400],
                            ),
                          ),
                          Gap(SizeToken.xxl),
                        ],
                      ),
                    )
                  : ListView.separated(
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
                          onTap: () => vm.goToMemory(context, memory.id),
                          onLongPress: () => vm.deleteMemoryFromAlbum(context, memory.id),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ExtendedImage.network(
                              getThumbnailUri(memory.files),
                              fit: BoxFit.cover,
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
                        ColorsToken.blackAlpha[400]!,
                        ColorsToken.black.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CircleAvatar(
                        backgroundColor:
                            vm.isShrink ? ColorsToken.black.withOpacity(0.3) : Colors.transparent,
                        child: IconButtonComp(
                          onPressed: context.pop,
                          icon: IconsToken(
                            color: vm.isShrink ? ColorsToken.white : ColorsToken.black,
                          ).altArrowLeftLinear,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => vm.editName(context),
                      child: Text(
                        vm.album?.name ?? '',
                        style: TypographyToken.textSm.copyWith(
                          color: vm.isShrink ? ColorsToken.white : ColorsToken.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        backgroundColor:
                            vm.isShrink ? ColorsToken.neutralAlpha : Colors.transparent,
                        child: IconButtonComp(
                          onPressed: () => vm.delete(context),
                          icon: IconsToken(
                            color: vm.isShrink ? ColorsToken.white : ColorsToken.black,
                          ).trashBinMinimalisticLinear,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
