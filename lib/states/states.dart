import 'package:flutter/cupertino.dart';

class UserState with ChangeNotifier {
  bool _login = true;

  bool get login => _login;

  set login(bool v) {
    _login = v;
    notifyListeners();
  }
}
