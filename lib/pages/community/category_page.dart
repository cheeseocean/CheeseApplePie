import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/pages/common/bubble_item.dart';
import 'package:cheese_flutter/widgets/open_container.dart';
import 'package:cheese_flutter/pages/common/publish_bubble_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

const double _fabDimension = 56.0;

class CategoryPage extends StatefulWidget {
  final String categoryName;
  CategoryPage({Key key, this.categoryName});
  @override
  State<StatefulWidget> createState() {
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  final toolbarHeight = 76.0;
  List<Bubble> _bubbleList = List<Bubble>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      print("delayed 1 seconds");
      Cheese.getBubbleListOfCategory(widget.categoryName,
              page: PageParameter(size: 6))
          .then((bubbleList) {
        print(bubbleList.toJson());
        setState(() {
          _bubbleList = bubbleList.content;
        });
      }).catchError((error) {
        print(error);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFAEFEFEA),
        floatingActionButton: OpenContainer(
          openColor: Colors.red,
          // openElevation: 4.0,
          transitionType: ContainerTransitionType.fade,
          openBuilder: (context, _) {
            return PublishBubblePage(fromCategory: widget.categoryName);
          },
          closedElevation: 6.0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_fabDimension / 2),
            ),
          ),
          closedColor: Colors.amber,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                brightness: Brightness.light,
                actions: [],
                leading: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                          "http://192.168.1.13/assets/images/bubble/test.jpg"),
                      Container(
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ),
                // bottom: PreferredSize(
                //     child: Text("hello"), preferredSize: Size.fromHeight(40)),
                pinned: true,
                backgroundColor: Color(0xFFFFFFFE),
                expandedHeight: 200,
                centerTitle: true,
                title: Text("板块", style: TextStyle(color: Colors.black)),
                forceElevated: innerBoxIsScrolled,
              )
            ];
          },
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Builder(
              builder: (context) {
                return EasyRefresh(
                    header: BallPulseHeader(),
                    footer: BallPulseFooter(),
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            print("refresh");
                            // _count = 20;
                          });
                        }
                      });
                    },
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            print("load more");
                            // _count += 10;
                          });
                        }
                      });
                    },
                    child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return getItem(_bubbleList[index]);
                        },
                        itemCount: _bubbleList.length));
              },
            ),
          ),
        ));
  }

  Widget getItem(Bubble bubble) {
    return BubbleItem(bubble: bubble);
  }
}
