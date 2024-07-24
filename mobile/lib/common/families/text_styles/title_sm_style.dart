import 'package:flutter/material.dart';

class TitleSmStyle extends TextStyle {
  const TitleSmStyle({
    Color? color,
    FontWeight? fontWeight,
    List<Shadow>? shadows,
  }) : super(
          fontSize: 24,
          color: color,
          fontWeight: fontWeight,
          shadows: shadows,
        );
}
