import 'package:cheese_flutter/res/colors.dart';
import 'package:cheese_flutter/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MomentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MomentsPageState();
  }
}

class _MomentsPageState extends State<MomentsPage> {
  List<Widget> _mondayContainer = <Widget>[];
  var sectionHeight = 40.0;
  static double _longPressDownDy = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("课程表"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 400.0,
          // color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: Week()),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(color: Colors.blue, child: Stack()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Week extends StatefulWidget {
  @override
  State createState() {
    return _WeekState();
  }
}

class _WeekState extends State<Week> {
  static var sectionHeight = 40.0;
  static double _longPressDownDy = 0.0;
  static double _firstLongPressDownEdge;
  List<Item> _items = <Item>[];

  static bool willDownExpand;
  static bool willUpShrink;
  static int start;
  static int length;

  @override
  void initState() {
    // TODO: implement initState
    _items.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        print("globalPosition${details.globalPosition}");
        print("localPosition${details.localPosition}");
        _longPressDownDy = details.localPosition.dy;
        start = _longPressDownDy ~/ sectionHeight;
        _firstLongPressDownEdge = start * sectionHeight;
        length = 1;
        print("last$_firstLongPressDownEdge");
        print(start);
        setState(() {
          _items.add(new Item(start: start, length: length));
        });
      },
      onLongPressMoveUpdate: (details) {
        // print("globalPosition${details.globalPosition}");
        // print("localPosition${details.localPosition}");

        willDownExpand =
            details.localPosition.dy > (start + length) * sectionHeight;
        willUpShrink =
            details.localPosition.dy < (start + length - 1) * sectionHeight;
        if (willDownExpand) {
          print("willDownExpand");
          setState(() {
            length++;
            _items.clear();
            _items.add(new Item(start: start, length: length));
          });
        }
        if (willUpShrink) {
          print("willUpShrink");
          setState(() {
            length--;
            _items.clear();
            _items.add(new Item(start: start, length: length));
          });
        }
      },
      child: Container(
          color: Colors.yellow,
          child: Stack(
            children: _items
                .map(
                  (item) =>
                  Positioned(
                    width: 180,
                    height: 40.0 * item.length,
                    top: item.start * sectionHeight,
                    child: Card(
                      color: Colors.grey,
                    ),
                  ),
            )
                .toList(),
          )),
    );
  }
}

class Item {
  int start;
  int length;
  String className;
  String teacherName;
  String classAddress;

  Item({this.start,
    this.length,
    this.classAddress,
    this.teacherName,
    this.className});
}
