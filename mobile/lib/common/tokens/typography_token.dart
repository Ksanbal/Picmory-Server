import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';

abstract final class TypographyToken {
  static final TextStyle titleLg = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: SizeToken.xxl,
    letterSpacing: 0.2,
    color: ColorsToken.black,
  );

  static final TextStyle titleMd = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeToken.xl,
    letterSpacing: 0.2,
    color: ColorsToken.black,
  );

  static final TextStyle titleSm = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeToken.l,
    letterSpacing: 0.2,
    color: ColorsToken.black,
  );

  static final TextStyle textLg = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SizeToken.ml,
    letterSpacing: 0.3,
    color: ColorsToken.black,
  );

  static final TextStyle textMd = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeToken.ml,
    letterSpacing: 0.4,
    color: ColorsToken.black,
  );

  static final TextStyle textSm = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: SizeToken.m,
    letterSpacing: 0.4,
    color: ColorsToken.black,
  );

  static final TextStyle captionMd = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: SizeToken.sm,
    letterSpacing: 0.4,
    color: ColorsToken.black,
  );

  static final TextStyle captionSm = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: SizeToken.sm,
    letterSpacing: 0.4,
    color: ColorsToken.black,
  );
}
