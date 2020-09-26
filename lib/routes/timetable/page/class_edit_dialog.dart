import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cheese_flutter/routes/timetable/page/timetable_page.dart';

class ClassEditDialog extends StatelessWidget {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _classAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        "添加课程",
      )),
      titlePadding: EdgeInsets.all(15.0),
      content: Container(
        height: 160.0,
        child: Column(
          children: [
            TextField(
              controller: _classNameController,
              decoration: InputDecoration(hintText: "课程名"),
            ),
            SizedBox(
              height: 5.0,
            ),
            TextField(
              controller: _teacherController,
              decoration: InputDecoration(
                hintText: "老师",
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            TextField(
              controller: _classAddressController,
              decoration: InputDecoration(hintText: "教室"),
            )
          ],
        ),
      ),
      // scrollable: true,
      buttonPadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(Response(result: false));
          },
          child: Text("取消"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(Response(
                result: true,
                details: ClassDetails(
                    className: _classNameController.text,
                    classAddress: _classAddressController.text,
                    teacherName: _teacherController.text)));
          },
          child: Text("完成"),
        ),
      ],

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }
}

class Response {
  bool result;
  ClassDetails details;

  Response({this.result, this.details});
}

class ClassDetails {
  final int color;
  final String className;
  final String teacherName;
  final String classAddress;

  ClassDetails(
      {this.color, this.className, this.teacherName, this.classAddress});
}
