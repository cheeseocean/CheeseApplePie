import 'dart:ui';

import 'package:cheese_flutter/routes/timetable/page/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home/page/home_page.dart';
import '../../community/page/community_page.dart';
import '../../mine/page/mine_page.dart';
import '../../timetable/page/timetable_page.dart';

class ContainerPage extends StatefulWidget {
  ContainerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}

class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.normalIcon, this.activeIcon);
}

class _ContainerPageState extends State<ContainerPage> {
  List<Widget> pages;

  final itemNames = [
    _Item("首页", "assets/svgs/ic_home_normal.svg",
        "assets/svgs/ic_home_active.svg"),
    _Item("课表", "assets/svgs/ic_timetable_normal.svg",
        "assets/svgs/ic_timetable_active.svg"),
    _Item("社区", "assets/svgs/ic_community_normal.svg",
        "assets/svgs/ic_community_active.svg"),
    _Item("我的", "assets/svgs/ic_person_normal.svg",
        "assets/svgs/ic_person_active.svg"),
  ];

  List<BottomNavigationBarItem> itemList;

  @override
  void initState() {
    super.initState();
    print("initState _ContainerPageState");
    if (pages == null) {
      pages = [HomePage(), TimetablePage(), CommunityPage(), MinePage()];
    }
  }

  int _selectIndex = 0;

  List<BottomNavigationBarItem> get _itemList => itemNames
      .map((item) => BottomNavigationBarItem(
          icon: SvgPicture.asset(item.normalIcon, width: 24.0, height: 24.0),
          label: item.name,
          activeIcon: SvgPicture.asset(
            item.activeIcon,
            width: 24.0,
            height: 24.0,
            // color: Color(0xffc6c9fd),
          )))
      .toList();

  //Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build _ContainerPageState");
    return Scaffold(
      body: Stack(
        children: [
          _getPagesWidget(0),
          _getPagesWidget(1),
          _getPagesWidget(2),
          _getPagesWidget(3),
        ],
      ),
      // backgroundColor: Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: IconThemeData(size: 24),
        // unselectedIconTheme: IconThemeData(size: 24),
        items: _itemList,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        unselectedFontSize: 12.0,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        // iconSize: 20,
        currentIndex: _selectIndex,
        type: BottomNavigationBarType.fixed,
        // fixedColor: Color.fromARGB(255, 0, 188, 86),
      ),
    );
  }
}
