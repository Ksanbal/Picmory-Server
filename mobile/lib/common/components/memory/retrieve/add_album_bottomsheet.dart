import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/common/utils/get_storage_uri.dart';
import 'package:picmory/models/api/memory/memory_model.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_add_album_viewmodel.dart';
import 'package:provider/provider.dart';

class AddAlbumBottomsheet extends StatelessWidget {
  const AddAlbumBottomsheet({super.key, required this.memory});

  final MemoryModel memory;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryAddAlbumViewmodel(),
      child: Consumer<MemoryAddAlbumViewmodel>(builder: (_, vm, __) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                scrollController.addListener(() {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    vm.loadMore();
                  }
                });
                return Container(
                  decoration: const BoxDecoration(
                    color: ColorsToken.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Center(
                      child: Column(
                        children: [
                          // 안내바
                          Container(
                            width: 70,
                            height: 4,
                            decoration: BoxDecoration(
                              color: ColorsToken.neutral[200],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Gap(SizeToken.ml),
                          // title
                          Text(
                            "추억함에 추가하기",
                            style: TypographyToken.textSm,
                          ),
                          Gap(SizeToken.ml),
                          // 추가 아이템
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => vm.createAlbumAndAdd(context, memory),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: ColorsToken.neutral[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: IconsToken(
                                        color: ColorsToken.neutral[600]!,
                                      ).addFolderLinear,
                                    ),
                                  ),
                                  Gap(SizeToken.s),
                                  Text(
                                    "새 추억함",
                                    style: TypographyToken.textSm,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 앨범 아이템
                          ...vm.albums.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => vm.toggleSelectedAlbumIds(e.id),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: ColorsToken.neutral[200],
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: ColorsToken.neutral[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: e.memoryCount > 0
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: ExtendedImage.network(
                                                getStorageUri(e.coverImagePath ?? ''),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.name,
                                              style: TypographyToken.textSm,
                                            ),
                                            Text(
                                              '${e.memoryCount}장',
                                              style: TypographyToken.captionSm.copyWith(
                                                color: ColorsToken.neutral[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    vm.selectedAlbumIds.contains(e.id)
                                        ? IconsToken(
                                            color: ColorsToken.positive,
                                          ).checkCircleBold
                                        : IconsToken(
                                            size: IconTokenSize.small,
                                          ).circle
                                  ],
                                ),
                              ),
                            );
                          }),
                          Gap(100),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // 투명 gradient
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorsToken.white.withOpacity(0),
                    ColorsToken.white,
                  ],
                ),
              ),
            ),
            // 완료버튼
            Padding(
              padding: const EdgeInsets.only(bottom: SizeToken.ml),
              child: PrimaryButtonComp(
                onPressed: () => vm.addAlbum(context, memory),
                text: "완료",
                textStyle: TypographyToken.textSm.copyWith(
                  color: ColorsToken.white,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
