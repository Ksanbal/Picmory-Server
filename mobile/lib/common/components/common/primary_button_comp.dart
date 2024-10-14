import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class PrimaryButtonComp extends StatelessWidget {
  const PrimaryButtonComp({
    super.key,
    required this.onPressed,
    required this.text,
    this.leading,
    this.textColor = ColorsToken.white,
    this.backgroundColor = ColorsToken.primary,
  });

  final void Function() onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: EffectsToken.pillRadius,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToken.m,
          vertical: SizeToken.s,
        ),
        decoration: BoxDecoration(
          borderRadius: EffectsToken.pillRadius,
          color: backgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              Gap(SizeToken.s),
            ],
            Text(
              text,
              style: TypographyToken.textMd.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
