import 'package:flutter/material.dart';

class TextSmStyle extends TextStyle {
  const TextSmStyle({
    Color? color,
  }) : super(
          fontSize: 18,
          color: color,
          overflow: TextOverflow.ellipsis,
        );
}
