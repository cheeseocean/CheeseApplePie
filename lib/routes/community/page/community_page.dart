import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'category_page.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommunityPageState();
  }
}

class _CommunityPageState extends State<CommunityPage> {
  static double toolbarHeight = 76.0;

  CategoryList _categoryList = CategoryList();

  @override
  void initState() {
    super.initState();
    print("community initState");
    Cheese.getCategoryList().then((categoryList) {
      print("getCategoryList");
      print(categoryList.toJson());
      _categoryList = categoryList;
      setState(() {});
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("CommunityPageState build");
    return _buildWidget();
  }

  Widget _buildWidget() {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(children: [
          Container(
            child: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: toolbarHeight,
                brightness: Brightness.light,
                elevation: 0.0,
                actions: [
                  // IconButton(
                  //   padding: EdgeInsets.only(top: 26),
                  //   color: Colors.amber,
                  //   icon: Icon(Icons.search),
                  //   onPressed: () {},
                  // )
                ]),
          ),

          Container(
            height: 150,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.cyan[300],
                );
              },
              itemCount: 5,
              viewportFraction: 0.8,
              scale: 0.9,
              autoplay: true,
              // pagination: new SwiperPagination(),//如果不填则不显示指示点
              // control: new SwiperControl(),//如果不填则不显示左右按钮
            ),
          ),
          ListTile(title: Text("Offical", style: TextStyle(color: Colors.amber, fontSize: 19.0, fontFamily: 'Chocolate'),)),
          // Container(
          //   height: 200,
          GridView.builder(
            shrinkWrap: true, //当内部Grid不能滑动时需配置此选项
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2.0),
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      // boxShadow: [BoxShadow(offset: Offset(0, 1))],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      gradient: LinearGradient(
                          colors: [Colors.lightBlue[100], Colors.cyan[100]])),
                  child: InkWell(
                    focusColor: Colors.yellow,
                    onTap: () {
                      NavigatorUtils.push(context, "/community/categories/${_categoryList.content[index].categoryName}");
                    },
                    child: Text(
                      _categoryList.content[index].categoryName,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ));
            },
            itemCount: _categoryList.totalElements ?? 0,
          )
        ]));
  }
}

class MyCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  MyCupertinoPageRoute({
    @required WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
