import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class MessagingSmComp extends StatelessWidget {
  const MessagingSmComp({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
  });

  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToken.xs,
        vertical: SizeToken.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorsToken.primary[100],
        borderRadius: EffectsToken.mdRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconsToken(
            color: textColor ?? ColorsToken.primary[600]!,
          ).dangerCircleBold,
          Gap(SizeToken.xxs),
          Text(
            text,
            style: TypographyToken.textSm.copyWith(
              color: textColor ?? ColorsToken.primary[600],
            ),
          ),
        ],
      ),
    );
  }
}
