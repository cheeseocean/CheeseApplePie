import 'package:cheese_flutter/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<String> semesters = [
  "大一上",
  "大一下",
  "大二上",
  "大二下",
  "大三上",
  "大三下",
  "大四上",
  "大四下"
];

class SemesterPicker extends StatefulWidget {
  final String currentSemester;

  SemesterPicker({this.currentSemester});

  @override
  State<StatefulWidget> createState() {
    return _SemesterPickerState();
  }
}

class _SemesterPickerState extends State<SemesterPicker> {
  String _selectedSemester;

  void onSelected(semester) {
    setState(() {
      _selectedSemester = semester;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedSemester = widget.currentSemester;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Center(child: Text("切换学期")),
      content: Container(
        height: 240,
        width: 200.0,
        child: GridView.count(
          // shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 2.0,
          children: semesters
              .map((semester) => Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: _selectedSemester == semester
                          ? Colors.amber
                          : Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: InkWell(
                      onTap: () {
                        onSelected(semester);
                      },
                      child: Center(child: Text(semester)))))
              .toList(),
        ),
      ),
      leftButtonLabel: "取消",
      rightButtonLabel: "确定",
      onRightPressed: (){
        Navigator.of(context).pop(_selectedSemester);
      },
      onLeftPressed: (){
        Navigator.of(context).pop("cancel");
      },
    );
  }
}
