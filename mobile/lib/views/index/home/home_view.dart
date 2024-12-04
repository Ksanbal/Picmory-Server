import 'package:animate_do/animate_do.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/tooltip_comp.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/tokens/asset_image_token.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/common/utils/get_thumbnail_uri.dart';
import 'package:picmory/main.dart';

import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final vm = Provider.of<HomeViewmodel>(context, listen: false);

  @override
  void initState() {
    analytics.logScreenView(screenName: "home");
    vm.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewmodel>(builder: (_, vm, __) {
      return CustomRefreshIndicator(
        onRefresh: () async {
          vm.changeCrossAxisCount();
        },
        builder: (BuildContext context, Widget child, IndicatorController controller) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              child,
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, _) {
                  if (controller.isIdle) return Container();

                  return Positioned(
                    top: controller.value * 50.0, // Adjust this value as needed
                    child: const Text(
                      "당겨서 뷰 바꾸기",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                },
              ),
            ],
          );
        },
        child: vm.memories == null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetImageToken.emptyHome,
                      ),
                      Gap(25),
                      Gap(SizeToken.m),
                      Text(
                        "첫 번째 추억을 추가하여\n갤러리를 채워주세요.",
                        textAlign: TextAlign.center,
                        style: TypographyToken.titleSm.copyWith(
                          color: ColorsToken.neutral[900],
                        ),
                      ),
                      Gap(SizeToken.xxl),
                    ],
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 16 + 96 + 11,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 500),
                      from: 50,
                      child: TooltipComp(
                        text: "QR코드로 추억을 불러오세요",
                        direction: MessagingSmDirection.down,
                      ),
                    ),
                  ),
                ],
              )
            : MasonryGridView.count(
                controller: vm.scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                crossAxisCount: vm.crossAxisCount,
                itemCount: (vm.memories ?? []).isEmpty ? 10 : (vm.memories ?? []).length,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                cacheExtent: 9999,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: MediaQuery.of(context).padding.bottom + 110,
                ),
                itemBuilder: (context, index) {
                  if ((vm.memories ?? []).isEmpty) {
                    return Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: getShimmer(index),
                      ),
                    );
                  }

                  final memory = (vm.memories ?? [])[index];

                  // 사진
                  return InkWell(
                    onTap: () => vm.goToMemoryRetrieve(context, memory),
                    child: Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
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
                    ),
                  );
                },
              ),
      );
    });
  }
}
