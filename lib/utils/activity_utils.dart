import 'package:flutter/material.dart';

Map<String, int> activityItemColorMap = {
  'food': 0xff7253BF,
  'water': 0xff3982EC,
  'sleep': 0xffED7061,
  'stress': 0xff7253BF,
  'stool': 0xffE0883B,
  'digestion': 0xFF5BC496,
};

Map<String, int> activityItemColorWithOpacityMap = {
  'food': 0x665BC496,
  'water': 0x663982EC,
  'sleep': 0x66ED7061,
  'stress': 0x667253BF,
  'stool': 0x66E0883B,
  'digestion': 0x667253BF,
};

Color getActivityItemColor(String activityName, [bool? withOpacity = false]) {

  if (withOpacity == false) {
    int? colorHex = activityItemColorMap[activityName];
    return colorHex != null ? Color(colorHex) : const Color(0xff7253BF);
  } else {
    int? colorHex = activityItemColorWithOpacityMap[activityName];
    return colorHex != null ? Color(colorHex) : const Color(0x667253BF);
  }
}

Map<String, int> foodMealColorMap = {
  'breakfast': 0xff5BC496,
  'lunch': 0xff3982EC,
  'dinner': 0xffED7061,
  'others': 0xff7253BF,
};

Map<String, int> foodMealColorWithOpacityMap = {
  'breakfast': 0x665BC496,
  'lunch': 0x663982EC,
  'dinner': 0x66ED7061,
  'others': 0x667253BF,
};

Color getFoodMealColor(String? mealName, [bool? withOpacity = false]) {
  if (withOpacity == false) {
    int? colorHex = foodMealColorMap[mealName];
    return colorHex != null ? Color(colorHex) : const Color(0xff7253BF);
  } else {
    int? colorHex = foodMealColorWithOpacityMap[mealName];
    return colorHex != null ? Color(colorHex) : const Color(0x667253BF);
  }
}
