import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class MessagingMdComp extends StatelessWidget {
  const MessagingMdComp({
    super.key,
    required this.text,
    this.buttonText,
    this.textColor,
    this.backgroundColor,
    this.buttonColor,
    this.onPressed,
  });

  final String text;
  final String? buttonText;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToken.m,
        vertical: SizeToken.s,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorsToken.neutralAlpha[800],
        borderRadius: EffectsToken.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TypographyToken.textSm.copyWith(
                color: textColor ?? ColorsToken.white,
              ),
            ),
          ),
          Gap(SizeToken.s),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeToken.m,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: buttonColor ?? ColorsToken.neutral[600],
              borderRadius: EffectsToken.mdRadius,
            ),
            child: Text(
              buttonText ?? "확인",
              style: TypographyToken.textSm.copyWith(
                color: ColorsToken.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
