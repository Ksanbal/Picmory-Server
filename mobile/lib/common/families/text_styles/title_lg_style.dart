import 'package:flutter/material.dart';

class TitleLgStyle extends TextStyle {
  const TitleLgStyle({
    Color? color,
    List<Shadow>? shadows,
  }) : super(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: color,
          shadows: shadows,
        );
}
