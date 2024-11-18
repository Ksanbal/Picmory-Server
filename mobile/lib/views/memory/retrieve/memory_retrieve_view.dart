import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/memory/retrieve/video_player.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/main.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class MemoryRetrieveView extends StatelessWidget {
  const MemoryRetrieveView({
    super.key,
    required this.memoryId,
  });

  final String memoryId;

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "memory retrieve");

    final vm = Provider.of<MemoryRetrieveViewmodel>(context, listen: false);
    vm.getMemory(int.parse(memoryId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 이미지
          Consumer<MemoryRetrieveViewmodel>(
            builder: (_, vm, __) {
              if (vm.memory == null) return Container();

              return PageView.builder(
                itemCount: vm.photos.length + vm.videos.length,
                itemBuilder: (_, index) {
                  if (index < vm.photos.length) {
                    final photo = vm.photos[index];

                    return ExtendedImage.network(
                      photo.uri,
                      mode: ExtendedImageMode.gesture,
                    );
                  } else {
                    final video = vm.videos[index - vm.photos.length];

                    return Padding(
                      padding: EdgeInsets.only(
                        top: 48 + MediaQuery.of(context).padding.top,
                        bottom: 48 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: VideoPlayer(
                        fromNetwork: true,
                        uri: video.uri,
                        file: null,
                      ),
                    );
                  }
                },
              );
            },
          ),
          // 상단
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                4,
                MediaQuery.of(context).padding.top,
                4,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 뒤로가기
                  InkWell(
                    onTap: () => vm.pop(context),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        SolarIconsOutline.altArrowLeft,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 삭제
                  InkWell(
                    onTap: () => vm.delete(context),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        SolarIconsOutline.trashBinMinimalistic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                4,
                MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 날짜 변경
                  Consumer<MemoryRetrieveViewmodel>(builder: (_, vm, __) {
                    return InkWell(
                      onTap: () => vm.showChangeDateBottomsheet(context),
                      child: Text(
                        vm.memory?.date != null
                            ? DateFormat('yyyy.MM.dd').format(vm.memory!.date)
                            : '',
                        style: const TitleSmStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 좋아요
                      Consumer<MemoryRetrieveViewmodel>(
                        builder: (_, value, __) {
                          final isLiked = vm.memory?.like ?? false;

                          return InkWell(
                            onTap: vm.likeMemory,
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                isLiked ? SolarIconsBold.heart : SolarIconsOutline.heart,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      // 앨범 추가
                      InkWell(
                        onTap: () => vm.showAddAlbumDialog(context),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            SolarIconsOutline.addFolder,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
