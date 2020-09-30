import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/course.dart';
import 'package:cheese_flutter/routes/timetable/widgets/class_edit_dialog.dart';
import 'package:cheese_flutter/routes/timetable/widgets/semester_picker.dart';
import 'package:cheese_flutter/routes/timetable/widgets/timetable_indicator.dart';
import 'package:cheese_flutter/utils/screen_util.dart';
import 'package:cheese_flutter/widgets/loading_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'course_model.dart';

final double weekPanelHeight = ScreenUtil.screenHeight;

final int classCount = 10;

final double sectionHeight = weekPanelHeight / classCount;

final int weekCount = 7;

final int weekFlex = 3;
final int timeFlex = 2;
final double perWeekWith =
    (ScreenUtil.screenWidth * weekFlex) / (weekFlex * weekCount + timeFlex);

bool adding = false;

var weekDay =
    DateUtil.getWeekday(DateTime.now(), languageCode: "zh", short: true);

class TimetablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimetablePageState();
  }
}

class _TimetablePageState extends State<TimetablePage> {
  var sectionHeight = 40.0;

  List weekNumbers = [0, 1, 2, 3, 4, 5, 6, 7];
  List weekLabels = [
    '时间',
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];
  TimetableModel _timetable;

  List<String> menuItems = ["上传云端", "更换学期", "修改背景"];

  void onMenuSelect(String feature) {}

  Widget get moreButton => PopupMenuButton(
        offset: Offset(0.0, 56.0),
        padding: EdgeInsets.all(0.0),
        icon: Icon(Icons.more_vert),
        onSelected: (feature) {
          switch (feature) {
            case "上传云端":
              showDialog(
                  context: context,
                  builder: (_) => LoadingDialog(),
                  barrierDismissible: false);

              Cheese.uploadTimetable(_timetable.courses).then((result) {
                print(result.toJson());
                showToast("${result.data}");
                Navigator.of(context).pop();
              }).catchError((error) {
                print(error.response.data);
                Navigator.of(context).pop();
              });
              break;
            case "更换学期":
              showDialog<String>(
                  context: context,
                  builder: (_) => SemesterPicker(
                        currentSemester: _timetable.currentSemester,
                      )).then((semester) {
                if (semesters.contains(semester)) {
                  // print("change semester:$semester");
                  _timetable.setCurrentSemester(semester);
                }
              });
              break;
            default:
              break;
          }
        },
        onCanceled: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        itemBuilder: (_) => menuItems
            .map((item) => PopupMenuItem(
                  child: Center(
                      child: Text(
                    item,
                    textAlign: TextAlign.center,
                  )),
                  value: item,
                ))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    print("timetable build");
    return ChangeNotifierProvider<TimetableModel>.value(
      value: TimetableModel(),
      child: Consumer<TimetableModel>(
        builder: (context, timetable, child) {
          _timetable = timetable;
          return GestureDetector(
            onTap: () {
              if (adding) {
                setState(() {
                  adding = false;
                });
              }
              timetable.setEditMode(false);
            },
            // behavior: HitTestBehavior.translucent,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  timetable.currentSemester,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  icon: Icon(Icons.eco_rounded),
                  onPressed: () {
                    timetable.setEditMode(!timetable.editMode);
                  },
                ),
                actions: [moreButton],
              ),
              body: Container(
                child: Column(
                  children: [
                    Container(
                      height: perWeekWith,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: weekLabels.map((label) {
                          if (label == "时间") {
                            return Expanded(
                                flex: timeFlex,
                                child: Center(
                                    child: Text(
                                  "${DateTime.now().month.toString()}月",
                                )));
                          } else
                            return Expanded(
                                flex: weekFlex,
                                child: Card(
                                  color: weekDay == label
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorLight,
                                  child: Center(
                                      child: Text(
                                    label,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w200),
                                  )),
                                ));
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          // color: Colors.blue,
                          height: weekPanelHeight,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: weekNumbers.map((num) {
                                if (num == 0)
                                  return Expanded(
                                      flex: timeFlex, child: TimeDashboard());
                                else
                                  return Expanded(
                                    flex: weekFlex,
                                    child: Week(
                                      weekNumber: num,
                                      semester: timetable.currentSemester,
                                    ),
                                  );
                              }).toList()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class Week extends StatefulWidget {
  final int weekNumber;
  final String semester;

  Week({this.weekNumber, this.semester});

  @override
  State createState() {
    print("weekNumber:$weekNumber createState");
    print("semester:$semester");
    return _WeekState();
  }
}

class _WeekState extends State<Week> {
  static double _originDownDy = 0.0;
  static double _originTopMargin;
  static double _originBottomMargin;
  List<Course> courseOfWeek = <Course>[];
  List<num> restBlock;
  List<num> consumedBlock;

  int start;
  int length;

  Course addButton;

  @override
  void initState() {
    super.initState();
    print("week:${widget.weekNumber} initState");
    // _items.clear();
  }

  @override
  void didUpdateWidget(Week oldWidget) {
    print("week:${widget.weekNumber} didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("week:${widget.weekNumber} deactivate");
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    print("week:${widget.weekNumber} didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("week:${widget.weekNumber} dispose");
    super.dispose();
  }

  void changeState() {
    setState(() {
      addButton = Course.instance(start: start, length: length);
    });
  }

  void addClass() async {
    final response = await showDialog<Response>(
        context: context,
        builder: (_) {
          return ClassEditDialog();
        },
        barrierDismissible: false);
    if (response.hasResult) {
      context.read<TimetableModel>().addCourse(Course.instance(
          semester: widget.semester,
          weekNumber: widget.weekNumber,
          start: start,
          length: length,
          className: response.details.className,
          classAddress: response.details.classAddress,
          teacherName: response.details.teacherName,
          color: response.details.color));
    }
    setState(() {
      if (adding) {
        adding = false;
        addButton = null;
      }
    });
  }

  void onLongPressStart(LongPressStartDetails details) {
    adding = true;
    _originDownDy = details.localPosition.dy;
    start = _originDownDy ~/ sectionHeight;
    _originTopMargin = _originDownDy - start * sectionHeight;
    _originBottomMargin = (start + 1) * sectionHeight - _originDownDy;
    length = 1;
    changeState();
  }

  void onLongPressMove(LongPressMoveUpdateDetails details) {
    bool up = false;

    double offsetY = details.localOffsetFromOrigin.dy;

    if (offsetY < 0) {
      offsetY = -offsetY;
      up = true;
    }
    double effectiveMargin = up ? _originBottomMargin : _originTopMargin;
    // print("effectiveMargin:$effectiveMargin");
    if (offsetY + effectiveMargin > length * sectionHeight) {
      length++;
      if (up) {
        //向上Expand超出范围
        if (--start < 0 || !restBlock.contains(start)) {
          start++;
          length--;
        }
      } else {
        //向下超出范围
        if (start + length > classCount ||
            !restBlock.contains(start + length - 1)) {
          length--;
        }
      }
      changeState();
    } else if (offsetY + effectiveMargin < (length - 1) * sectionHeight) {
      length--;
      if (up) start++;
      changeState();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("week:${widget.weekNumber} build");
    restBlock = List.generate(10, (index) => index);
    consumedBlock = [];
    courseOfWeek = Provider.of<TimetableModel>(context).courses;
    courseOfWeek = courseOfWeek
        .where((course) =>
            course.weekNumber == widget.weekNumber &&
            course.semester == widget.semester)
        .toList();
    courseOfWeek.forEach((course) {
      consumedBlock.addAll(
          List.generate(course.length, (index) => index + course.start));
      // restBlock.removeRange(course.start, course.start + course.length - 1);
    });
    // print(consumedBlock);
    // courseOfWeek.forEach((element) {
    //   print(element.toJson());
    // });
    restBlock.removeWhere((index) => consumedBlock.contains(index));
    print(restBlock);
    return GestureDetector(
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMove,
      onSecondaryLongPressMoveUpdate: (details) {
        print("secondary:${details.localOffsetFromOrigin}");
      },
      child: Material(
        // color: Colors.red,
        child: Stack(children: buildChildren()),
      ),
    );
  }

  List<Widget> buildChildren() {
    List<Widget> container = <Widget>[];
    if (adding && addButton != null) {
      container.add(Positioned(
        width: perWeekWith,
        height: sectionHeight * addButton.length,
        top: addButton.start * sectionHeight,
        child: FlatButton(
            color: Colors.grey[300],
            child: Icon(
              Icons.add_rounded,
              size: 18.0,
            ),
            onLongPress: () {},
            onPressed: addClass),
      ));
    }
    container.addAll(courseOfWeek
        .map((course) => DisplayCard(
              course: course,
              deleteActive: Provider.of<TimetableModel>(context).editMode,
            ))
        .toList());
    return container;
  }
}

class DisplayCard extends StatelessWidget {
  final Course course;
  final bool deleteActive;

  DisplayCard({this.course, this.deleteActive});

  @override
  Widget build(BuildContext context) {
    // if (course != null) {
    //   print(course.toJson());
    // }
    print(course.color);
    return Positioned(
      width: perWeekWith,
      height: sectionHeight * course.length,
      top: course.start * sectionHeight,
      child: GestureDetector(
        onLongPress: () {
          print("onLongPress");
          context.read<TimetableModel>().setEditMode(!deleteActive);
        },
        child: Card(
          color: Color(course.color),
          child: Stack(alignment: Alignment.center, children: [
            Positioned.fill(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: Text(
                        course.className,
                        style: TextStyle(fontSize: 13.0, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: Text(
                        course.classAddress,
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),

                    // Text(course.teacherName)
                  ]),
            ),
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<TimetableModel>().removeCourse(course);
                  },
                  child: Opacity(
                    opacity: deleteActive ? 1.0 : 0.0,
                    child: SvgPicture.asset(
                      "assets/svgs/ic_trashcan.svg",
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
