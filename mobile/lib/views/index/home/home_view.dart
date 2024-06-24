import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picmory/common/components/get_shimmer.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/main.dart';

import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "home");

    final vm = Provider.of<HomeViewmodel>(context, listen: false);
    vm.init();

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
            ? const Center(
                child: Text(
                  "👇 추억을 추가해주세요 👇",
                  style: TitleSmStyle(),
                ),
              )
            : MasonryGridView.count(
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
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
