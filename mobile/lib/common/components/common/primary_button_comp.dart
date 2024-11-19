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
    this.textStyle,
    this.textColor = ColorsToken.white,
    this.backgroundColor = ColorsToken.primary,
    this.borderColor,
  });

  final void Function() onPressed;
  final String text;
  final TextStyle? textStyle;
  final Color textColor;
  final Color backgroundColor;
  final Widget? leading;
  final Color? borderColor;

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
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              Gap(SizeToken.s),
            ],
            Text(
              text,
              style: textStyle ?? TypographyToken.textMd.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
