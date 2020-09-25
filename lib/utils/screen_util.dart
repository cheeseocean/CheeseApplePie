
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ScreenUtil{

  static double get screenHeight {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
    return mediaQueryData.size.height;
  }
  static double get screenWidth {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
    return mediaQueryData.size.width;
  }

}