import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:solar_icons/solar_icons.dart';

class AddAlbumBottomsheet extends StatelessWidget {
  const AddAlbumBottomsheet({
    super.key,
    required this.albums,
    required this.vm,
  });

  final List<AlbumModel> albums;
  final MemoryRetrieveViewmodel vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 70,
            decoration: BoxDecoration(
              color: ColorFamily.disabledGrey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Text(
              "추억함에 추가하기",
              style: TitleSmStyle(),
            ),
          ),
          SizedBox(
            // height: 130,
            height: 160,
            child: ListView.separated(
              itemCount: albums.length + 1,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: 95,
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorFamily.disabledGrey300,
                              ),
                              child: const Center(
                                child: Icon(
                                  SolarIconsOutline.addFolder,
                                  color: ColorFamily.textGrey600,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "새 추억함",
                              style: TextSmStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final album = albums[index - 1];

                return InkWell(
                  onTap: () => vm.addAlbum(context, album.id),
                  child: SizedBox(
                    width: 95,
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: 1 < album.imageUrls.length
                              ? multipleImageAlbum(album.imageUrls)
                              : singleImageAlbum(album.imageUrls),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            album.name,
                            maxLines: 2,
                            style: const TextSmStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget multipleImageAlbum(List<String> imageUrls) {
    return Stack(
      children: [
        // 우하단
        Align(
          alignment: Alignment.bottomRight,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: ColorFamily.disabledGrey400,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ExtendedImage.network(
                  imageUrls[1],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        // 좌상단
        AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: ColorFamily.disabledGrey400,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ExtendedImage.network(
                imageUrls[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget singleImageAlbum(List<String> imageUrls) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: ColorFamily.disabledGrey400,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ExtendedImage.network(
          imageUrls[0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
