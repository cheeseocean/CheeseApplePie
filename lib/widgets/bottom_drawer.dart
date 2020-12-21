import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef DrawerListener = void Function(bool isOpen);

class BottomDrawer extends StatefulWidget {
  BottomDrawer(
      {this.openDrawerRatio = 0.4,
      this.closeDrawerRatio = 0.1,
      this.header,
      this.child,
      this.drawerRadius = 15.0,
      this.color = const Color(0xFFFFFFFF),
      this.drawerListener});

  DrawerListener drawerListener;
  double openDrawerRatio;
  double closeDrawerRatio;
  Widget header;
  Widget child;
  double drawerRadius;
  Color color;

  @override
  State<StatefulWidget> createState() {
    return _BottomDrawerState();
  }
}

class _BottomDrawerState extends State<BottomDrawer>
    with TickerProviderStateMixin {
  CurvedAnimation curve;
  double offsetDistance = 0.0;
  AnimationController animationController;
  Animation<double> animation;
  double openDrawerHeight;
  double closeDrawerHeight;
  bool isOpen;

  double startOffset;

  @override
  void initState() {
    super.initState();
    // print("init: $closeDrawerHeight, max: $openDrawerHeight");
    isOpen = false;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    if (widget.drawerListener == null) {
      widget.drawerListener = (isOpen) {};
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      if (openDrawerHeight == null && closeDrawerHeight == null) {
        ///计算抽屉可展开的最大值
        openDrawerHeight =
            MediaQuery.of(context).size.height * widget.openDrawerRatio;

        ///计算抽屉关闭时的高度
        closeDrawerHeight =
            MediaQuery.of(context).size.height * widget.closeDrawerRatio;
      }
      moveTOBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    offsetDistance = offsetDistance.clamp(0.0, openDrawerHeight);
    // print("build: $offsetDistance, openDrawerHeight: $openDrawerHeight");
    return Transform.translate(
        offset: Offset(0.0, offsetDistance),
        child: RawGestureDetector(
          gestures: {MyVerticalDragGestureRecognizer: getRecognizer()},
          child: Container(
            height: openDrawerHeight,
            child: _buildDrawer(),
          ),
        ));
  }

  Widget _buildDrawer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(3.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
        color: widget.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.drawerRadius),
          topRight: Radius.circular(widget.drawerRadius),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: closeDrawerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.header,
                GestureDetector(
                    onTap: () {
                      if (isOpen) {
                        moveTOBottom();
                      } else {
                        moveToTop();
                      }
                    },
                    child: isOpen
                        ? Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF999999),
                          )
                        : Icon(Icons.keyboard_arrow_up_rounded,
                            color: Color(0xFF999999)))
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          Container(
            height: openDrawerHeight - closeDrawerHeight,
            child: NotificationListener(
              child: widget.child,
              onNotification: _onChildScrollNotification,
            ),
          )
        ],
      ),
    );
  }

  bool _onChildScrollNotification(Notification notification) {
    switch (notification.runtimeType) {
      case ScrollEndNotification:
        // print("滚动停止");
        _onEnd((notification as ScrollEndNotification).dragDetails);
        break;
      case OverscrollNotification:
        // print("滚动到边界");
        OverscrollNotification overscrollNotification = notification;
        if (isOpen) {
          offsetDistance =
              offsetDistance + overscrollNotification.dragDetails.delta.dy;
          setState(() {});
        }
        break;
    }
  }

  GestureRecognizerFactoryWithHandlers<MyVerticalDragGestureRecognizer>
      getRecognizer() {
    return GestureRecognizerFactoryWithHandlers(
        () => MyVerticalDragGestureRecognizer(), this._initializer);
  }

  void _initializer(MyVerticalDragGestureRecognizer instance) {
    instance
      ..onStart = _onStart
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd;
  }

  ///接受触摸事件
  void _onStart(DragStartDetails details) {
    // print('触摸屏幕${details.globalPosition}');
  }

  ///垂直移动
  void _onUpdate(DragUpdateDetails details) {
    // print('垂直移动${details.delta}');
    offsetDistance = offsetDistance + details.delta.dy;
    // print("offsetDistance: $offsetDistance");
    setState(() {});
  }

  ///手指离开屏幕
  void _onEnd(DragEndDetails details) {
    // print('离开屏幕:$offsetDistance');

    if (!isOpen) {
      //非打开状态, 向上滑动距离超过临界值则自动滑至顶部
      if (offsetDistance < (openDrawerHeight - closeDrawerHeight) / 2) {
        moveToTop();
      } else {
        //未超过临界值, 回到底部
        moveTOBottom();
      }
    } else {
      if (offsetDistance > (openDrawerHeight - closeDrawerHeight) / 2) {
        moveTOBottom();
      } else {
        moveToTop();
      }
    }
  }

  void moveToTop() {
    double end = 0;
    double start = offsetDistance;

    ///动画变化满园
    animation = Tween(begin: start, end: end).animate(curve)
      ..addListener(() {
        offsetDistance = animation.value;
        setState(() {});
      });

    ///开启动画
    animationController.reset();
    animationController.forward();
    isOpen = true;
  }

  void moveTOBottom() {
    double end = openDrawerHeight - closeDrawerHeight;
    double start = offsetDistance;

    ///动画变化满园
    animation = Tween(begin: start, end: end).animate(curve)
      ..addListener(() {
        offsetDistance = animation.value;
        setState(() {});
      });

    ///开启动画
    animationController.reset();
    animationController.forward();
    isOpen = false;
  }
}

class MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  MyVerticalDragGestureRecognizer({Object debugOwner})
      : super(debugOwner: debugOwner);
}
