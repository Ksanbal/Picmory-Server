import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/viewmodels/index/for_you/albums/albums_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AlbumsViewmodel>(
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

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ExtendedImage.network(
                      memory.photoUri,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
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
                    Text(
                      vm.album?.name ?? '',
                      style: TitleSmStyle(
                        color: vm.isShrink ? Colors.white : Colors.black,
                        fontWeight: vm.isShrink ? FontWeight.bold : FontWeight.normal,
                        shadows: vm.isShrink
                            ? [
                                Shadow(
                                  color: const Color(0xff212529).withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: const Color(0xff212529).withOpacity(0.32),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        backgroundColor: vm.isShrink
                            ? ColorFamily.textGrey700.withOpacity(0.7)
                            : Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            SolarIconsOutline.trashBinMinimalistic,
                          ),
                          color: vm.isShrink ? Colors.white : Colors.black,
                          onPressed: context.pop,
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
