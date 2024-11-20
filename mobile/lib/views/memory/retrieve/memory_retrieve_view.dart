import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/components/memory/retrieve/video_player.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/common/utils/get_storage_uri.dart';
import 'package:picmory/main.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryRetrieveView extends StatefulWidget {
  const MemoryRetrieveView({
    super.key,
    required this.memoryId,
  });

  final String memoryId;

  @override
  State<MemoryRetrieveView> createState() => _MemoryRetrieveViewState();
}

class _MemoryRetrieveViewState extends State<MemoryRetrieveView> {
  late final vm = Provider.of<MemoryRetrieveViewmodel>(context, listen: false);

  @override
  void initState() {
    analytics.logScreenView(screenName: "memory retrieve");
    vm.getMemory(int.parse(widget.memoryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsToken.black,
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
                      getStorageUri(photo.path),
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
                        uri: getStorageUri(video.path),
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
                SizeToken.m,
                MediaQuery.of(context).padding.top,
                SizeToken.m,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 뒤로가기
                  IconButtonComp(
                    onPressed: context.pop,
                    icon: IconsToken(
                      color: ColorsToken.white,
                    ).altArrowLeftLinear,
                    backgroundColor: ColorsToken.neutralAlpha[500]!,
                  ),
                  // 삭제
                  IconButtonComp(
                    onPressed: () => vm.delete(context),
                    icon: IconsToken(
                      color: ColorsToken.white,
                    ).trashBinMinimalisticLinear,
                    backgroundColor: ColorsToken.neutralAlpha[500]!,
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
                SizeToken.m,
                0,
                SizeToken.m,
                MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 날짜 변경
                  Consumer<MemoryRetrieveViewmodel>(
                    builder: (_, vm, __) {
                      return InkWell(
                        onTap: () => vm.showChangeDateBottomsheet(context),
                        child: Text(
                          vm.memory?.date != null
                              ? DateFormat('yyyy.MM.dd').format(vm.memory!.date)
                              : '',
                          style: TypographyToken.titleMd.copyWith(
                            color: ColorsToken.white,
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 좋아요
                      Consumer<MemoryRetrieveViewmodel>(
                        builder: (_, value, __) {
                          final isLiked = vm.memory?.like ?? false;

                          return IconButtonComp(
                            onPressed: vm.likeMemory,
                            icon: isLiked
                                ? IconsToken(
                                    color: ColorsToken.white,
                                  ).heartBold
                                : IconsToken(
                                    color: ColorsToken.white,
                                  ).heartLinear,
                          );
                        },
                      ),
                      // 앨범 추가
                      IconButtonComp(
                        onPressed: () => vm.showAddAlbumDialog(context),
                        icon: IconsToken(
                          color: ColorsToken.white,
                        ).addFolderLinear,
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
