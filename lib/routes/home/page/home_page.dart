import 'dart:ui';

import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:cheese_flutter/widgets/labele_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

final defaultMargin = EdgeInsets.symmetric(horizontal: 10.0);

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return _HomePageState();
  }
}

TextStyle get labelStyle => TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
    );

class _HomePageState extends State<HomePage> {

  List<WebViewShortcut> shortcuts = [
    WebViewShortcut(requestUrl: "http://www.nut.edu.cn/", icon: Icon(Icons.local_library_rounded, color: Colors.blue[200],), label: "学校官网"),
    WebViewShortcut(requestUrl: "http://117.40.249.4/jwweb/", icon: Icon(Icons.school_rounded, color: Colors.blue[200]), label: "教务系统"),
    WebViewShortcut(requestUrl: "http://mg.ac.senlanit.com/", icon: Icon(Icons.sensor_door_rounded, color: Colors.blue[200]), label: "门禁云"),
    WebViewShortcut(requestUrl: "http://cz.senlanit.com/recharge/index.php", icon: Icon(Icons.flash_on_rounded, color: Colors.blue[200]), label: "缴电费"),
    WebViewShortcut(requestUrl: "www.nut.edu.cn", icon: Icon(Icons.widgets_rounded, color: Colors.blue[200]), label: "全部组件"),
  ];

  List<Widget> unknownButtons = [
    Container(child: Center(child: Text("hello"))),
    Container(child: Center(child: Text("hello"))),
  ];

  Widget get banner => SliverToBoxAdapter(
        child: Container(
          height: 150,
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.cyan[300],
              );
            },
            itemCount: 3,
            viewportFraction: 0.8,
            scale: 0.9,
            autoplay: true,
            pagination: new SwiperPagination(), //如果不填则不显示指示点
            // control: new SwiperControl(),//如果不填则不显示左右按钮
          ),
        ),
      );

  Widget get schoolSectionHeader => SliverToBoxAdapter(
          child: ListTile(
              title: Text(
        "School",
        style: TextStyle(
            color: Colors.amber, fontSize: 19.0, fontFamily: 'Chocolate'),
      )));

  Widget get hotVideoSectionHeader => SliverToBoxAdapter(
        child: ListTile(
          title: Text(
            "Hot Video",
            style: TextStyle(
                color: Colors.amber, fontSize: 19.0, fontFamily: 'Chocolate'),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: EasyRefresh.custom(
        slivers: [
          banner,
          schoolSectionHeader,
          SliverGrid(
              delegate: SliverChildBuilderDelegate((_, index) {
                return LabelButton(icon: shortcuts[index].icon, label: Text(shortcuts[index].label), onTap: (){
                  NavigatorUtils.goWebViewPage(context, "test", shortcuts[index].requestUrl);
                },);
              }, childCount: 5),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((_, index) {
                return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    // padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(child: SvgPicture.asset("assets/svgs/deliver.svg", width: 32.0, height: 32.0,)));
              }, childCount: 2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
              )),
          hotVideoSectionHeader,
        ],
      ),
    );
  }
}

class WebViewShortcut{
  final String requestUrl;
  final Widget icon;
  final String label;
  WebViewShortcut({this.requestUrl, this.icon, this.label});
}