import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_md_style.dart';
import 'package:solar_icons/solar_icons.dart';

class CreateAlbumBottomsheet extends StatelessWidget {
  const CreateAlbumBottomsheet({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          14,
          16,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: context.pop,
                      child: const Icon(
                        SolarIconsOutline.altArrowLeft,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "새로운 추억함의 이름을 지어주세요",
                      style: TextSmStyle(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(39, 0, 39, 20),
              child: TextFormField(
                controller: controller,
                style: const TitleMdStyle(),
                textAlign: TextAlign.center,
                maxLength: 20,
                buildCounter: (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) {
                  return Center(
                    child: Text(
                      "$currentLength/$maxLength",
                      style: const CaptionSmStyle(),
                    ),
                  );
                },
                cursorColor: ColorFamily.disabledGrey400,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorFamily.disabledGrey400,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorFamily.disabledGrey400,
                    ),
                  ),
                ),
              ),
            ),
            RoundedButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  controller.text = hintText;
                }
                context.pop();
              },
              child: const Text(
                "완료",
                style: TextSmStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
