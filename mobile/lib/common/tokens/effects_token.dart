import 'package:flutter/material.dart';

abstract final class EffectsToken {
  /// Shadow 1
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      blurRadius: 1,
      color: Color(0x21252952),
    ),
    BoxShadow(
      blurRadius: 10,
      offset: Offset(0, 4),
      color: Color(0x2125291A),
    ),
  ];

  /// Round corners - pill_radius
  ///
  /// 200px for buttons
  static final BorderRadius pillRadius = BorderRadius.circular(200);

  /// Round corners - md_radius
  ///
  /// 20px for modals
  static final BorderRadius mdRadius = BorderRadius.circular(20);

  /// Round corners - sm_radius
  ///
  /// 10px for cards
  static final BorderRadius smRadius = BorderRadius.circular(10);
}
