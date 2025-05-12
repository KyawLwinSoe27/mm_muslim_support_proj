import 'package:flutter/material.dart';

import 'package:mm_muslim_support/core/enums/font_family.dart';

TextStyle arabicTextStyle({required Color color}) {
  return TextStyle(
    fontSize: 20,
    color: color,
    fontFamily: FontFamily.scheherazade.name, // Optional Arabic font
  );
}
