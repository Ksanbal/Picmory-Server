import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
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
    final vm = Provider.of<MemoryRetrieveViewmodel>(context, listen: true);
    vm.getMemory(int.parse(memoryId));

    return Scaffold(
      backgroundColor: vm.isFullScreen ? Colors.black : ColorFamily.disabledGrey400,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: vm.memory == null
                ? Container()
                : InkWell(
                    onTap: vm.toggleFullScreen,
                    splashColor: Colors.transparent,
                    child: ExtendedImage.network(
                      vm.memory!.photoUri,
                      mode: ExtendedImageMode.gesture,
                    ),
                  ),
          ),
          // 하단 선택바
          vm.isFullScreen
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 76 + MediaQuery.of(context).padding.bottom,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: Row(
                      children: [
                        // 정보 토글
                        Expanded(
                          child: IconButton(
                            icon: const Icon(SolarIconsOutline.infoCircle),
                            onPressed: () {},
                          ),
                        ),
                        // 좋아요
                        Expanded(
                          child: IconButton(
                            icon: Consumer<MemoryRetrieveViewmodel>(
                              builder: (_, vm, __) {
                                final isLiked = vm.memory?.isLiked ?? false;

                                return Icon(
                                  isLiked ? SolarIconsBold.heart : SolarIconsOutline.heart,
                                  color: isLiked ? ColorFamily.error : null,
                                );
                              },
                            ),
                            onPressed: vm.likeMemory,
                          ),
                        ),
                        // 앨범 추가
                        Expanded(
                          child: IconButton(
                            icon: const Icon(SolarIconsOutline.addFolder),
                            onPressed: () => vm.showAddAlbumDialog(context),
                          ),
                        ),
                        // 삭제
                        Expanded(
                          child: IconButton(
                            icon: const Icon(SolarIconsOutline.trashBinMinimalistic),
                            onPressed: () => vm.delete(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          // 뒤로가기 버튼
          vm.isFullScreen
              ? Container()
              : Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  child: InkWell(
                    // onTap: context.pop,
                    onTap: () => vm.pop(context),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        SolarIconsOutline.altArrowLeft,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
