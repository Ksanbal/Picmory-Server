import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class ModalComp extends StatelessWidget {
  const ModalComp({
    super.key,
    required this.title,
    this.subtitle,
    this.body,
    this.imageSource,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String? subtitle;
  final String? body;
  final ImageProvider? imageSource;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: SizeToken.m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeToken.ml),
          child: Container(
            decoration: BoxDecoration(
              color: ColorsToken.white,
              boxShadow: EffectsToken.shadow1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageSource != null)
                  SizedBox(
                    width: double.infinity,
                    height: 164.0,
                    child: Image(
                      image: imageSource!,
                      fit: BoxFit.cover,
                    ),
                  ),
                // 텍스트 영역
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    SizeToken.m,
                    SizeToken.l,
                    SizeToken.m,
                    SizeToken.m,
                  ),
                  child: Column(
                    children: [
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: TypographyToken.captionSm.copyWith(
                            color: ColorsToken.primary,
                          ),
                        ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TypographyToken.textMd,
                      ),
                    ],
                  ),
                ),
                // 본문
                if (body != null)
                  Text(
                    body!,
                    textAlign: TextAlign.center,
                    style: TypographyToken.textSm.copyWith(
                      color: ColorsToken.neutral[400]!,
                    ),
                  ),
                Gap(SizeToken.xl),
                // 버튼 영역
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeToken.m,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryButtonComp(
                          onPressed: onCancel,
                          text: cancelText,
                          textColor: ColorsToken.black,
                          backgroundColor: ColorsToken.neutral[50]!,
                        ),
                      ),
                      Gap(SizeToken.s),
                      Expanded(
                        child: PrimaryButtonComp(
                          onPressed: onConfirm,
                          text: confirmText,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(SizeToken.ml),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
