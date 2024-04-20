import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/models/album/album_model.dart';
import 'package:solar_icons/solar_icons.dart';

class AddAlbumBottomsheet extends StatefulWidget {
  const AddAlbumBottomsheet({
    super.key,
    required this.albums,
    required this.onCreateAlbum,
    required this.onCompleted,
  });

  final List<AlbumModel> albums;
  final Function() onCreateAlbum;
  final Function(List<int> ids) onCompleted;

  @override
  State<AddAlbumBottomsheet> createState() => _AddAlbumBottomsheetState();
}

class _AddAlbumBottomsheetState extends State<AddAlbumBottomsheet> {
  // 선택한 추억함 id 목록
  final List<int> selectedAlbumIds = [];
  toggleSelectedAlbumIds(int id) {
    if (selectedAlbumIds.contains(id)) {
      selectedAlbumIds.remove(id);
    } else {
      selectedAlbumIds.add(id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
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
                          color: ColorFamily.disabledGrey400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // title
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "추억함에 추가하기",
                          style: TextSmStyle(),
                        ),
                      ),
                      // 추가 아이템
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: widget.onCreateAlbum,
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: ColorFamily.disabledGrey400,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  SolarIconsOutline.addFolder,
                                  color: ColorFamily.disabledGrey500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  "새 추억함",
                                  style: TextSmStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 앨범 아이템
                      ...widget.albums.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => toggleSelectedAlbumIds(e.id),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: 1 < e.imageUrls.length
                                      ? multipleImageAlbum(e.imageUrls)
                                      : singleImageAlbum(e.imageUrls),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextSmStyle(),
                                        ),
                                        Text(
                                          '${e.imageUrls.length}장',
                                          style: const CaptionSmStyle(
                                            color: ColorFamily.textGrey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                selectedAlbumIds.contains(e.id)
                                    ? const Icon(
                                        SolarIconsBold.checkCircle,
                                        color: ColorFamily.positive,
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: ColorFamily.disabledGrey400,
                                            width: 1,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
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
                Colors.white.withOpacity(0),
                Colors.white,
              ],
            ),
          ),
        ),
        // 완료버튼
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: RoundedButton(
            onPressed: () => widget.onCompleted(selectedAlbumIds),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "완료",
                style: TextSmStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
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
