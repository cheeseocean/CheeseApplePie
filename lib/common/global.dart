import 'package:cheese_flutter/routes/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/cacheConfig.dart';
import 'dart:convert';

import '../api/cheese.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {

  static const String API_BASE_URL = 'http://api.cheese.beer';
  static const String STATIC_BASE_URL = 'http://static.cheese.beer';
  static SharedPreferences _prefs;

  static Profile profile = Profile();

  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;
    
    Cheese.init();
    Routers.init();
  }

  static saveProfile() {
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
}
