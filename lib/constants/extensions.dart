import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get themeData => Theme.of(this);
}