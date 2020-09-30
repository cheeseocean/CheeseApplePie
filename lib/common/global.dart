import 'package:cheese_flutter/models/course.dart';
import 'package:cheese_flutter/routes/routers.dart';
import 'package:cheese_flutter/utils/log_utils.dart';
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

  // static const String API_BASE_URL = 'http://api.cheese.beer';
  //android虚拟机访问Localhost
  static const String API_BASE_URL = 'http://10.0.2.2:5147';
  // static const String STATIC_BASE_URL = 'http://static.cheese.beer';
  static SharedPreferences _prefs;

  static Profile profile = Profile();

  static List<Course> timetable = <Course>[];

  static String currentSemester;

  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    // _prefs.clear();
    var _profile = _prefs.getString("profile");
    List<String> _timetable = _prefs.getStringList("timetable");
    var _semester = _prefs.getString("currentSemester");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    if(_timetable != null){
      try{
        timetable = _timetable.map((item) => Course.fromJson(jsonDecode(item))).toList();
        print(timetable.map((e) => print(e.toJson())));
      }catch(e){
        print(e);
      }
    }
    if(_semester != null){
      currentSemester = _semester;
    }else
      currentSemester = "大一";
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;
    // _prefs.clear();
    Log.init();
    Cheese.init();
    Routers.init();
  }

  static saveProfile() {
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
  
  static saveTimetable(){
    _prefs.setStringList("timetable", timetable.map((course) => jsonEncode(course.toJson())).toList());
  }
  static saveCurrentSemester(){
    _prefs.setString("currentSemester", currentSemester);
  }
}
