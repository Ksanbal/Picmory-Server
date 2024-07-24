import 'package:flutter/material.dart';

class TitleLgStyle extends TextStyle {
  const TitleLgStyle({
    Color? color,
    List<Shadow>? shadows,
  }) : super(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: color,
          shadows: shadows,
        );
}
