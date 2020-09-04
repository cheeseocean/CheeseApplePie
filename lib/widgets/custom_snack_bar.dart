import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({@required Widget content, Duration duration})
      : super(
          content: content,
          duration: duration,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)))
        );
}
