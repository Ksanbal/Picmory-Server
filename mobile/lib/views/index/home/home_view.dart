import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/custom_chip_widget.dart';
import 'package:picmory/common/families/text_styles/title_lg_style.dart';
import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewmodel>(context, listen: false);

    vm.init();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // 해시태그 목록
          Consumer<HomeViewmodel>(
            builder: (_, vm, __) {
              if (vm.hashtags.isEmpty) return Container();

              return SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.hashtags.length,
                    padding: const EdgeInsets.only(left: 16),
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final hashtag = vm.hashtags[index];

                      return CustomChipWidget(
                        label: hashtag,
                        onTap: () => vm.onTapHashtags(hashtag),
                        isSelected: vm.selectedHashtags.contains(hashtag),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // 기억 목록
          Expanded(
            child: Consumer<HomeViewmodel>(builder: (_, vm, __) {
              return Stack(
                children: [
                  CustomRefreshIndicator(
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
                    child: MasonryGridView.count(
                      crossAxisCount: vm.crossAxisCount,
                      itemCount: vm.memories.length,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      cacheExtent: 9999,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 110,
                      ),
                      itemBuilder: (context, index) {
                        final memory = vm.memories[index];

                        // 사진
                        return InkWell(
                          onTap: () => vm.goToMemoryRetrieve(context, memory),
                          child: Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ExtendedImage.network(
                                memory.photoUri,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      DateFormat('yyyy. MM').format(DateTime.now()),
                      style: TitleLgStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
