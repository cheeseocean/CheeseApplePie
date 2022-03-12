import 'package:flutter/material.dart';
import 'package:flutter_application/layout.dart';
import '../pages/user/login/login.dart';
import '../pages/user/register/register.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const LayoutPage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
};
