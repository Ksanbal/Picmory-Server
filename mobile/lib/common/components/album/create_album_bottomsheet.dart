import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

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
              padding: EdgeInsets.symmetric(vertical: SizeToken.ml),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: context.pop,
                      child: IconsToken().altArrowLeftLinear,
                    ),
                  ),
                  Center(
                    child: Text(
                      "새로운 추억함의 이름을 지어주세요",
                      style: TypographyToken.textSm,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(39, 0, 39, 20),
              child: TextFormField(
                controller: controller,
                style: TypographyToken.titleMd,
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
                      style: TypographyToken.captionSm.copyWith(
                        color: ColorsToken.neutral[700],
                      ),
                    ),
                  );
                },
                cursorColor: ColorsToken.neutral[500],
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TypographyToken.titleMd.copyWith(
                    color: ColorsToken.neutral[500],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsToken.neutral[500]!,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsToken.neutral[500]!,
                    ),
                  ),
                ),
              ),
            ),
            PrimaryButtonComp(
              onPressed: () {
                if (controller.text.isEmpty) {
                  controller.text = hintText;
                }
                context.pop();
              },
              text: "완료",
              textStyle: TypographyToken.textSm.copyWith(
                color: ColorsToken.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
