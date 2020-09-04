import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/home_page.dart';
import 'community/community_page.dart';
import 'mine/mine_page.dart';
import 'moments/moments_page.dart';

class ContainerPage extends StatefulWidget {
  ContainerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}

class _Item {
  String name, activeIcon, noramlIcon;

  _Item(this.name, this.activeIcon, this.noramlIcon);
}

class _ContainerPageState extends State<ContainerPage> {
  List<Widget> pages;

  final itemNames = [
    _Item("首页", "assets/svgs/ic_tab_home_active.svg",
        "assets/svgs/ic_tab_home_active.svg"),
    _Item("瞬间", "assets/svgs/ic_tab_moments_active.svg",
        "assets/svgs/ic_tab_moments_active.svg"),
    _Item("社区", "assets/svgs/ic_tab_community_active.svg",
        "assets/svgs/ic_tab_community_active.svg"),
    _Item("我的", "assets/svgs/ic_tab_mine_active.svg",
        "assets/svgs/ic_tab_mine_active.svg"),
  ];

  List<BottomNavigationBarItem> itemList;

  @override
  void initState() {
    super.initState();
    print("initState _ContainerPageState");
    if (pages == null) {
      pages = [HomePage(), MomentsPage(), CommunityPage(), MinePage()];
    }
    if (itemList == null) {
      itemList = itemNames
          .map((item) => BottomNavigationBarItem(
              icon:
                  SvgPicture.asset(item.noramlIcon, width: 28.0, height: 28.0),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 10.0),
              ),
              activeIcon: SvgPicture.asset(
                item.activeIcon,
                width: 30.0,
                height: 30.0,
              )))
          .toList();
    }
  }

  int _selectIndex = 0;

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
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: BottomNavigationBar(
        items: itemList,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        iconSize: 24,
        currentIndex: _selectIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Color.fromARGB(255, 0, 188, 86),
      ),
    );
  }
}
