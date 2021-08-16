import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cheese_flutter/routes/timetable/page/timetable_page.dart';

class TimeDashboard extends StatefulWidget {
  @override
  State createState() {
    return _TimeDashboardState();
  }
}

class _TimeDashboardState extends State<TimeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(children: buildChildren()));
  }

  List<Widget> buildChildren() {
    return List.generate(10, (index) => index)
        .map((e) => Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: showTimePicker,
              child: Text((e+1).toString()),
            )))
        .toList();
  }

  void showTimePicker() {}
}
