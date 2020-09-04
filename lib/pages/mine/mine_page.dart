import 'dart:convert';
import 'dart:io';

import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/global.dart';
import 'package:cheese_flutter/common/notifiers.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/widgets/sample_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

final String settingsAssetName = "assets/svgs/ic_settings.svg";

final List<String> _tabs = ['我的动态', '我的评论'];

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  final cheese = Cheese();
  User _user;

  static double toolbarHeight = 56.0;
  static double headerHeight = 400.0;
  static double tabBarHeight = 50.0;
  static double avatarSize = 88.0;

  @override
  void initState() {
    super.initState();
    print("MinePageState initState");
    _user = Global.profile.user ?? null;
    if (_user == null) {
      _user = User();
      Cheese.getUserInfo().then((user) {
        print('getUser');
        _user = user;
        Provider.of<UserModel>(context, listen: false).user = _user;
        print('finish');
      }).catchError((err) => print(err));
    }
  }

  final settingsAction = IconButton(
    icon: SvgPicture.asset(
      settingsAssetName,
      width: 24.0,
      height: 24.0,
    ),
    onPressed: () {},
  );

  final tabBarWidget = PreferredSize(
      preferredSize: Size(double.infinity, 46.0),
      child: Material(
        color: Color(0xFFEFEFEA),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400], width: 0.32),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        ),
        child: TabBar(
          // These are the widgets to put in each tab in the tab bar.
          indicatorColor: Colors.amber,
          indicatorWeight: 2.0,
          labelColor: Colors.grey[600],
          indicatorSize: TabBarIndicatorSize.label,
          tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        ),
      ));

  Widget build(BuildContext context) {
    //引发错误
    // showToast("mine page");
    print("MinePageState build");
    print(jsonEncode(_user));

    //TODO 这里有BUG未处理
    Provider.of<UserModel>(context).user;
    // if (_user == null) {
    //   Future.delayed(Duration(seconds: 1), () {

    //   });
    // }

    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            //
            SliverAppBar(
                actions: [settingsAction],
                toolbarHeight: toolbarHeight,
                brightness: Brightness.light,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        // padding: EdgeInsets.only(bottom: 160),
                        margin: EdgeInsets.only(bottom: headerHeight / 2),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.5),
                            end: Alignment(0.0, 0.0),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                        child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: headerHeight / 2, bottom: tabBarHeight),
                        decoration: BoxDecoration(
                            color: Color(0xFFEFEFEA),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Placeholder(
                              color: Colors.transparent,
                              fallbackHeight: avatarSize - 25,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, bottom: 10),
                              child: Text(
                                _user == null
                                    ? "用户未加载"
                                    : _user.nickname ?? "昵称未加载",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                _user == null ? "用户未加载" : _user.bio ?? "个签未加载",
                                style: TextStyle(
                                    // color: Colors.grey[800],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: Container(
                          height: avatarSize,
                          width: avatarSize,
                          child: InkWell(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              backgroundImage: _user.avatarUrl != null
                                  ? NetworkImage(_user.avatarUrl)
                                  : AssetImage(
                                      "assets/images/avatar_placeholder.jpg"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                pinned: true,
                backgroundColor: Color(0xFFEFEFEA),
                expandedHeight: headerHeight,
                centerTitle: true,
                title: Text("Mine", style: TextStyle(color: Colors.black)),
                forceElevated: innerBoxIsScrolled,
                bottom: tabBarWidget)
          ];
        },
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: _tabs.map((String name) {
            return SliverContainer(name: name);
          }).toList(),
        ),
      ),
    );
  }
}

class SliverContainer extends StatefulWidget {
  final String name;

  SliverContainer({
    Key key,
    @required this.name,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SliverContainerState();
  }
}

class _SliverContainerState extends State<SliverContainer> {
  List<String> postList;

  @override
  void initState() {
    super.initState();
    print("init state ${widget.name}");

    if (postList == null || postList.isEmpty) {
      postList = fetchPostData(widget.name);
    }
  }

  List<String> fetchPostData(String requestUrl) {
    return List<String>.generate(_count, (index) {
      return "index $index";
    });
  }

  @override
  Widget build(BuildContext context) {
    return getContentSlivers(context, postList);
  }

  int _count = 10;

  double bubbleSliverItemHeight = 80.0;
  double commentSliverItemHeight = 40.0;

  getContentSlivers(BuildContext context, List<String> list) {
    if (list == null || list.isEmpty) {
      print("no data");
      return SizedBox(
          height: 100,
          width: 200,
          child: Card(
            color: Colors.red,
            child: Center(child: Text("noData")),
          ));
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) {
          return EasyRefresh.custom(
            // enableControlFinishLoad: true,
            // enableControlFinishRefresh: true,

            header: BallPulseHeader(color: Colors.amber
                // backgroundColor: Colors.amber[100],
                ),
            footer: BallPulseFooter(color: Colors.amber),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    ((BuildContext context, int index) {
                  return getItem(list, index);
                }), childCount: _count),
              ),
            ],
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    print("refresh");
                    _count = 20;
                  });
                }
              });
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    print("load more");
                    _count += 10;
                  });
                }
              });
            },
          );
        },
      ),
    );
  }

  getItem(List<String> list, int index) {
    // String item = list[index];
    // return Container(
    //   height: bubbleSliverItemHeight,
    //   child: Card(
    //     color: Colors.indigoAccent,
    //     child: Text(item),
    //   ),
    // );
    // print(item);
    return SampleListItem();
  }
}
