import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

//안드로이드 형태(#ffffffff)로 가져오고 싶을 때
parseColor(String colorStr) {
  try {
    int index = colorStr.indexOf('#');
    if (index == 0) {
      colorStr = colorStr.substring(index + 1, colorStr.length);
    }

    if (colorStr.isNotEmpty && colorStr.length <= 8) {
      return Color(int.parse("0x${colorStr.padLeft(8, 'f')}"));
    } else {
      throw Exception("String Color Size Error!!");
    }
  } catch (e) {
    log('$e');
    return Colors.black;
  }
}

class AppColors {
  static const ColorFilter greyScale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}
