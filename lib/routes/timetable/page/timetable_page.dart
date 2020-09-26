import 'package:cheese_flutter/res/colors.dart';
import 'package:cheese_flutter/routes/timetable/page/class_edit_dialog.dart';
import 'package:cheese_flutter/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

final double weekPanelHeight = ScreenUtil.screenHeight;

final double sectionHeight = weekPanelHeight / 10;

final int weekCount = 7;

bool adding = false;

Item addButton = Item();

class TimetablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return _TimetablePageState();
  }
}

class _TimetablePageState extends State<TimetablePage> {
  var sectionHeight = 40.0;
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("课程表"),
        // leadingWidth: 24.0,
        leading: IconButton(
          icon: Icon(Icons.eco_rounded),
          onPressed: () {
            setState(() {
              _showDelete = !_showDelete;
            });
          },
          color: Colors.blue,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: null,
            color: Colors.blue,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // print("tap");
          if (adding) {
            adding = false;
            addButton = null;
          }
          setState(() {
            _showDelete = false;
          });
        },
        child: Container(
          height: weekPanelHeight,
          // color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expanded(flex: 1, child: TimeIndicator()),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 1,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 2,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 3,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 4,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 5,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 6,
                    deleteButtonHook: _showDelete,
                  )),
              Expanded(
                  flex: 2,
                  child: Week(
                    weekNumber: 7,
                    deleteButtonHook: _showDelete,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Week extends StatefulWidget {
  final int weekNumber;
  final bool deleteButtonHook;

  Week({this.weekNumber, this.deleteButtonHook});

  @override
  State createState() {
    print("weekNumber:$weekNumber createState");
    print("Week:$deleteButtonHook");
    return _WeekState();
  }
}

class _WeekState extends State<Week> {
  static double _originDownDy = 0.0;
  static double _originTopMargin;
  static double _originBottomMargin;
  static bool active = false;

  List<Item> _items = <Item>[];
  List<DeletableCard> _cards = <DeletableCard>[];

  static int start;
  static int length;

  get items => _items;

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
      addButton = Item(start: start, length: length);
    });
  }

  void addClass() async {
    final response = await showDialog<Response>(
      context: context,
      builder: (_) {
        return ClassEditDialog();
      },
      barrierDismissible: false
    );
    setState(() {
      if (!response.result) {
        if (adding) {
          adding = false;
          active = false;
        }
      }
      else {
        if (adding) {
          adding = false;
          active = false;
        }
        _items.add(Item(
            start: addButton.start,
            length: addButton.length,
            className: response.details.className,
            classAddress: response.details.classAddress,
            teacherName: response.details.teacherName
        ));
      }
    });
  }

  void onLongPressStart(LongPressStartDetails details) {
    active = true;
    adding = true;
    _originDownDy = details.localPosition.dy;
    start = _originDownDy ~/ sectionHeight;
    _originTopMargin = _originDownDy - start * sectionHeight;
    _originBottomMargin = (start + 1) * sectionHeight - _originDownDy;
    // print("_topMargin$_originTopMargin");
    // print("_bottomMarin$_originBottomMargin");
    length = 1;
    setState(() {
      addButton = Item(start: start, length: length);
    });
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
      if (up) start--;
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
    return GestureDetector(
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMove,
      child: Container(
        // color: Colors.grey[50],
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.symmetric(
                vertical: BorderSide(width: 0.5, color: Colors.grey[200]))),
        child: Stack(children: buildChildren()),
      ),
    );
  }

  List<Widget> buildChildren() {
    List<Widget> container = <Widget>[];
    if (active & adding) {
      container.add(stackChildWrapper(
        addButton,
        FlatButton(
            color: Colors.grey[300],
            child: Icon(
              Icons.add,
              size: 20.0,
            ),
            onLongPress: () {},
            onPressed: addClass),
      ));
    }
    container.addAll(
      _items.map((item) {
        DeletableCard card = DeletableCard(
          item: item,
          showDeleteButton: widget.deleteButtonHook,
        );

        return stackChildWrapper(
            item,
            DeletableCard(
              item: item,
              showDeleteButton: widget.deleteButtonHook,
            ));
      }),
    );
    return container;
  }

  Widget stackChildWrapper(Item item, Widget child) {
    return Positioned(
        width: ScreenUtil.screenWidth / weekCount,
        height: sectionHeight * item.length,
        top: item.start * sectionHeight,
        child: child);
  }
}

// ignore: must_be_immutable
class DeletableCard extends StatefulWidget {
  final Item item;
  final bool showDeleteButton;
  final VoidCallback onDeleteTap;

  DeletableCard({this.item, this.onDeleteTap, this.showDeleteButton});

  @override
  State createState() {
    return _DeletableCardState();
  }
}

class _DeletableCardState extends State<DeletableCard> {
  @override
  Widget build(BuildContext context) {
    print("card: showDeleteButton:${widget.showDeleteButton}");
    return GestureDetector(
      onLongPress: () {},
      child: Card(
        color: Colors.yellow,
        child: Stack(children: [
          Positioned.fill(
            child: Column(children: [
              Text(widget.item.className),
              Text(widget.item.classAddress),
              Text(widget.item.teacherName)
            ]),
          ),
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: widget.onDeleteTap,
                child: Opacity(
                  opacity: widget.showDeleteButton ? 1.0 : 0.0,
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
    );
  }
}

class Item {
  int weekNumber;
  int start;
  int length;
  int color;
  String className;
  String teacherName;
  String classAddress;

  Item({this.weekNumber,
    this.start,
    this.length,
    this.classAddress,
    this.teacherName,
    this.className,
    this.color});
}
