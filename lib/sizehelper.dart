import 'package:flutter/material.dart';

class SizeHelper {
  static MediaQueryData _query;
  static double deviceHeight;
  static double deviceWidth;
  static double availableSpaceVertical;
  static double availableSpaceHorizontal;
  static double paddingVertical;
  static double paddingHorizontal;

  static void init(BuildContext context) {
    _query = MediaQuery.of(context);
    _query.size.height;
    _query.size.width;
    paddingVertical = _query.padding.top + _query.padding.bottom;
    paddingHorizontal = _query.padding.left + _query.padding.right;
    availableSpaceVertical = deviceHeight - paddingVertical;
    availableSpaceHorizontal = deviceWidth - paddingHorizontal;
  }
}
