import 'package:flutter/material.dart';

abstract final class ColorsToken {
  /// Base Black
  static const Color black = Color(0xFF070A12);

  /// Base White
  static const Color white = Color(0xFFFFFFFF);

  /// Brand Primary
  ///
  /// The main brand color
  static MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFEBEFFF),
      100: Color(0xFFD6E0FF),
      200: Color(0xFFA8BDFF),
      300: Color(0xFF809DFF),
      400: Color(0xFF527AFF),
      500: Color(_primaryValue),
      600: Color(0xFF0037EB),
      700: Color(0xFF002AB3),
      800: Color(0xFF001B75),
      900: Color(0xFF000E3D),
      950: Color(0xFF00071F),
    },
  );
  static const _primaryValue = 0xFF295BFF;

  /// Neutral
  ///
  /// The base palette for text, border and background tokens
  static MaterialColor neutral = MaterialColor(
    _neutralValue,
    <int, Color>{
      50: Color(0xFFf7f8f8),
      100: Color(0xFFe6e6e9),
      200: Color(0xFFd4d5d9),
      300: Color(0xFFbfc1c7),
      400: Color(0xFFadb0b7),
      500: Color(_neutralValue),
      600: Color(0xFF666a79),
      700: Color(0xFF404557),
      800: Color(0xFF33394c),
      900: Color(0xFF1a2035),
      950: Color(0xFF00071f),
    },
  );
  static const _neutralValue = 0xFF8c8f9a;

  /// Positive
  ///
  /// Used to communicate positive feedback and success
  static MaterialColor positive = MaterialColor(
    _positiveValue,
    <int, Color>{
      50: Color(0xFFE5FAF5),
      100: Color(0xFFCFF7EC),
      200: Color(0xFFA0EED9),
      300: Color(0xFF6CE5C4),
      400: Color(0xFF3CDCB0),
      500: Color(_positiveValue),
      600: Color(0xFF1B9875),
      700: Color(0xFF147157),
      800: Color(0xFF0E4E3C),
      900: Color(0xFF07271E),
      950: Color(0xFF03110D),
    },
  );
  static const _positiveValue = 0xFF22BF94;

  /// Negative
  ///
  /// Used to communicate negative feedback, critical states/errors or destructive actions
  static MaterialColor negative = MaterialColor(
    _negativeValue,
    <int, Color>{
      50: Color(0xFFFEF1F1),
      100: Color(0xFFFDE3E3),
      200: Color(0xFFFAC7C7),
      300: Color(0xFFF8AFAF),
      400: Color(0xFFF59393),
      500: Color(_negativeValue),
      600: Color(0xFFED3535),
      700: Color(0xFFCA1212),
      800: Color(0xFF830C0C),
      900: Color(0xFF420606),
      950: Color(0xFF210303),
    },
  );
  static const _negativeValue = 0xFFF37777;

  /// Warning
  ///
  /// Used to communicate warning states and information that needs user attention
  static MaterialColor warning = MaterialColor(
    _warningValue,
    <int, Color>{
      50: Color(0xFFFEFCF1),
      100: Color(0xFFFDF8E3),
      200: Color(0xFFFAF0C1),
      300: Color(0xFFF8E9A5),
      400: Color(0xFFF6E288),
      500: Color(_warningValue),
      600: Color(0xFFEFCB29),
      700: Color(0xFFC3A20E),
      800: Color(0xFF806B09),
      900: Color(0xFF423705),
      950: Color(0xFF211C02),
    },
  );
  static const _warningValue = 0xFFF4DB6A;

  /// Neutral Alpha
  ///
  /// Varying levels of transparency that helps UI adapt to different backgrounds and elevations
  static MaterialColor neutralAlpha = MaterialColor(
    _neutralAlphaValue,
    <int, Color>{
      5: Color(_neutralAlphaValue).withOpacity(0.05),
      10: Color(_neutralAlphaValue).withOpacity(0.10),
      20: Color(_neutralAlphaValue).withOpacity(0.20),
      30: Color(_neutralAlphaValue).withOpacity(0.30),
      40: Color(_neutralAlphaValue).withOpacity(0.40),
      50: Color(_neutralAlphaValue).withOpacity(0.50),
      60: Color(_neutralAlphaValue).withOpacity(0.60),
      70: Color(_neutralAlphaValue).withOpacity(0.70),
      80: Color(_neutralAlphaValue).withOpacity(0.80),
      90: Color(_neutralAlphaValue).withOpacity(0.90),
      95: Color(_neutralAlphaValue).withOpacity(0.95),
    },
  );
  static const _neutralAlphaValue = 0xFF33394C;

  /// White Alpha
  ///
  /// Varying levels of transparency that helps UI adapt to different backgrounds and elevations
  static MaterialColor whiteAlpha = MaterialColor(
    _whiteAlphaValue,
    <int, Color>{
      5: Color(_whiteAlphaValue).withOpacity(0.05),
      10: Color(_whiteAlphaValue).withOpacity(0.10),
      20: Color(_whiteAlphaValue).withOpacity(0.20),
      30: Color(_whiteAlphaValue).withOpacity(0.30),
      40: Color(_whiteAlphaValue).withOpacity(0.40),
      50: Color(_whiteAlphaValue).withOpacity(0.50),
      60: Color(_whiteAlphaValue).withOpacity(0.60),
      70: Color(_whiteAlphaValue).withOpacity(0.70),
      80: Color(_whiteAlphaValue).withOpacity(0.80),
      90: Color(_whiteAlphaValue).withOpacity(0.90),
      95: Color(_whiteAlphaValue).withOpacity(0.95),
    },
  );
  static const _whiteAlphaValue = 0xFFFFFFFF;

  /// Black Alpha
  ///
  /// Varying levels of transparency that helps UI adapt to different backgrounds and elevations
  static MaterialColor blackAlpha = MaterialColor(
    _blackAlphaValue,
    <int, Color>{
      5: Color(_blackAlphaValue).withOpacity(0.05),
      10: Color(_blackAlphaValue).withOpacity(0.10),
      20: Color(_blackAlphaValue).withOpacity(0.20),
      30: Color(_blackAlphaValue).withOpacity(0.30),
      40: Color(_blackAlphaValue).withOpacity(0.40),
      50: Color(_blackAlphaValue).withOpacity(0.50),
      60: Color(_blackAlphaValue).withOpacity(0.60),
      70: Color(_blackAlphaValue).withOpacity(0.70),
      80: Color(_blackAlphaValue).withOpacity(0.80),
      90: Color(_blackAlphaValue).withOpacity(0.90),
      95: Color(_blackAlphaValue).withOpacity(0.95),
    },
  );
  static const _blackAlphaValue = 0xFF070A12;
}
