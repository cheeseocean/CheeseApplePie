import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("CommunityPageState build");
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Scaffold(
        appBar: AppBar(
          title: Text("社区"),
        ),
        body: ListView(children: [
          Container(
            height: 100.0,
            padding: EdgeInsets.only(right: 10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "如果只是路过, 我在终点等你",
                style: TextStyle(fontSize: 20.0, fontFamily: "LiuJianMa"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                  child: Align(
                alignment: Alignment.bottomRight,
                child: Text("---每日一句"),
              ))
            ]),
          ),

          ListTile(
              title: Text(
            "Offical",
            style: TextStyle(
                color: Colors.amber, fontSize: 19.0, fontFamily: 'Chocolate'),
          )),
          // Container(
          //   height: 200,
          GridView.builder(
            shrinkWrap: true,
            //当内部Grid不能滑动时需配置此选项
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
                        colors: [Colors.lightBlue[300], Colors.cyan[600]])),
                child: InkWell(
                  focusColor: Colors.yellow,
                  onTap: () {
                    NavigatorUtils.push(context,
                        "/community/categories/${_categoryList.content[index].categoryName}");
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_categoryList.content[index].categoryName,
                            style: TextStyle(fontSize: 19.0)),
                        Text(
                          _categoryList.content[index].description,
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 12.0),
                        )
                      ]),
                ),
              );
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
