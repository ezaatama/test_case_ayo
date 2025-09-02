// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';

class ColorUI {
  static const Color PRIMARY = Color(0xFF7A5AF8);
  static const Color PRIMARY_DARK = Color(0xFF4D37A5);
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color BLACK = Color(0xFF000000);
  static const Color TEXT_INK100 = Color(0xFF25282B);
  static const Color TEXT_INK80 = Color(0xFF52575C);
  static const Color TEXT_INK40 = Color(0xFFCACCCF);
  static const Color TEXT_INK10 = Color(0xFFE8E8E8);
  static const Color TEXT_INK0 = Color(0xFFF1F1F1);
  static const Color GREEN = Color(0xFF00C48C);
  static const Color GREEN_LIGHT = Color(0xFFE3F6F1);
  static const Color RED = Color(0xFFF44335);
  static const Color RED_LIGHT = Color(0xFFFDE3E1);
  static const Color RED_DARK = Color(0xFF7E051A);
  static const Color FILL_CHIP = Color(0xFFF5E6E9);
  static Color OVERLAY = Color(0XFF161C24).withValues(alpha: .8);
}

class FontUI {
  static const FontWeight WEIGHT_LIGHT = FontWeight.w300;
  static const FontWeight WEIGHT_SEMI_LIGHT = FontWeight.w400;
  static const FontWeight WEIGHT_REGULAR = FontWeight.w500;
  static const FontWeight WEIGHT_SEMI_BOLD = FontWeight.w600;
  static const FontWeight WEIGHT_BOLD = FontWeight.w700;
}

class BorderUI {
  static const double RADIUS_BUTTON = 8.0;
}

class TextStyleUI {
  static const TextStyle SUBTITLE1 = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 16,
  );
  static TextStyle SUBTITLE2 = TextStyle(fontFamily: 'Rubik', fontSize: 14);
  static TextStyle FILTER_SET = TextStyle(fontFamily: 'Rubik', fontSize: 14);
  static TextStyle BODY1 = TextStyle(fontFamily: 'Rubik', fontSize: 72);
  static TextStyle BODY2 = TextStyle(fontFamily: 'Rubik', fontSize: 14);
  static TextStyle BODY3 = TextStyle(fontFamily: 'Rubik', fontSize: 12);
  static TextStyle BODY4 = TextStyle(fontFamily: 'Rubik', fontSize: 9);
  static TextStyle CAPTION1 = TextStyle(fontFamily: 'Rubik', fontSize: 12);
}
