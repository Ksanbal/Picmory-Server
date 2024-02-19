import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewmodel>(context, listen: false);

    vm.clearDatas();

    vm.loadMemories();
    vm.loadHashtags();

    return SafeArea(
      child: Column(
        children: [
          // 해시태그 목록
          Consumer<HomeViewmodel>(
            builder: (_, vm, __) {
              if (vm.hashtags.isEmpty) return Container();

              return SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.hashtags.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final hashtag = vm.hashtags[index];
                    return InkWell(
                      onTap: () => vm.onTapHashtags(hashtag),
                      child: Chip(
                        label: Text(hashtag),
                        backgroundColor:
                            vm.selectedHashtags.contains(hashtag) ? Colors.blue : Colors.white,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // 기억 모록
          Expanded(
            child: Consumer<HomeViewmodel>(builder: (_, vm, __) {
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
                child: MasonryGridView.count(
                  crossAxisCount: vm.crossAxisCount,
                  itemCount: vm.memories.length,
                  itemBuilder: (context, index) {
                    final memory = vm.memories[index];

                    // 사진
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Card(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            memory.photoUri,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
              // return EasyRefresh(
              //   onRefresh: () => Future.delayed(const Duration(seconds: 3)),
              //   header: ClassicHeader(
              //     processedDuration: Duration.zero,
              //     showMessage: false,
              //     textBuilder: (context, state, text) {
              //       return Text('당겨서 뷰 바꾸기');
              //     },
              //   ),
              //   child: MasonryGridView.count(
              //     crossAxisCount: 2,
              //     itemCount: vm.memories.length,
              //     itemBuilder: (context, index) {
              //       final memory = vm.memories[index];

              //       // 사진
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 0),
              //         child: Card(
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(10),
              //             child: Image.network(
              //               memory.photoUri,
              //               fit: BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // );
            }),
          ),
        ],
      ),
    );
  }
}
