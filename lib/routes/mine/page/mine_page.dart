import 'dart:convert';
import 'dart:io';

import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/global.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/common/bubble_list_widget.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:cheese_flutter/routes/mine/mine_router.dart';
import 'package:cheese_flutter/utils/screen_util.dart';
import 'package:cheese_flutter/widgets/sample_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

final String settingsAssetName = "assets/svgs/ic_settings.svg";

final List<String> _tabs = ['帖子', '动态'];

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  final cheese = Cheese();
  User _user;

  ScrollController _controller = ScrollController();

  static double toolbarHeight = 56.0;
  static double headerHeight = 300.0;
  static double tabBarHeight = 50.0;
  static double avatarSize = 88.0;

  double _avatarOpacity = 0.0;

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
    print(ScreenUtil.screenHeight);
    _controller.addListener(() {
      print("offset:${_controller.offset}");
      setState(() {
        double result = _controller.offset / 260;

        _avatarOpacity =
            _controller.offset / 260 >= 1.0 ? 1.0 : _controller.offset / 260;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget get settingsButton => IconButton(
        icon: SvgPicture.asset(
          settingsAssetName,
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () {
          NavigatorUtils.push(context, MineRouter.settingsPage);
        },
      );

  Widget get tabBarWidget => PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: Material(
          color: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
          ),
          child: TabBar(
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize.label,
              // indicator: const BoxDecoration(),
              tabs: _tabs
                  .map((name) => Tab(
                        text: name,
                      ))
                  .toList()),
        ),
      );

  Widget get userProfile => Container(
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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/mine_header_bg.jpg",
                ),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: avatarSize,
                width: avatarSize,
                child: Hero(
                  tag: "avatar",
                  child: InkWell(
                    onTap: () {
                      NavigatorUtils.push(context, MineRouter.userDetailsPage);
                    },
                    child: CircleAvatar(
                      // backgroundColor: Colors.amber,
                      backgroundImage: _user.avatarUrl != null
                          ? NetworkImage(_user.avatarUrl)
                          : AssetImage("assets/images/avatar_placeholder.jpg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  _user == null ? "用户未加载" : _user.nickname ?? "昵称未加载",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  _user == null ? "用户未加载" : _user.bio ?? "个签未加载",
                  style: TextStyle(
                      // color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    label: Text("95后"),
                    backgroundColor: Colors.amberAccent[400],
                  ),
                  Chip(
                    label: Text("17软本2班"),
                    backgroundColor: Colors.lightBlue[300],
                  ),
                  Chip(
                    label: Text("江西上饶"),
                    backgroundColor: Colors.cyan[300],
                  )
                ],
              )
            ],
          ),
        ),
      );

  Widget build(BuildContext context) {
    //TODO 这里有BUG未处理
    Provider.of<UserModel>(context).user;

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColorLight,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).canvasColor,
                actions: [settingsButton],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: userProfile,
                ),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Opacity(
                    opacity: _avatarOpacity,
                    child: InkWell(
                      onTap: () {
                      },
                      child: CircleAvatar(
                        // backgroundColor: Colors.amber,
                        backgroundImage: _user.avatarUrl != null
                            ? NetworkImage(_user.avatarUrl)
                            : AssetImage(
                                "assets/images/avatar_placeholder.jpg"),
                      ),
                    ),
                  ),
                ),
                leadingWidth: 42.0,
                pinned: true,
                expandedHeight: ScreenUtil.screenHeight / 2,
                forceElevated: innerBoxIsScrolled,
                bottom: tabBarWidget,
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return BubbleListWidget(requestResUrl: "/user/posts");
            }).toList(),
          ),
        ),
      ),
    );
  }
}
