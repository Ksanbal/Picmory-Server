import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';

Future<bool?> showConfirmDelete(
  BuildContext context, {
  String title = "삭제",
}) async {
  return await showDialog(
    context: context,
    useSafeArea: true,
    barrierColor: ColorsToken.blackAlpha[400],
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pop(false),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButtonComp(
                      onPressed: () => context.pop(true),
                      text: "삭제",
                      textColor: ColorsToken.negative[600]!,
                      backgroundColor: ColorsToken.white,
                    ),
                  ),
                  Gap(SizeToken.s),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButtonComp(
                      onPressed: () => context.pop(false),
                      text: "취소",
                      textColor: ColorsToken.black,
                      backgroundColor: ColorsToken.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
