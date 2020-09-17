import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/global.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/common/bubble_details_page.dart';
import 'package:cheese_flutter/routes/common/item_wrapper.dart';
import 'package:cheese_flutter/routes/common/bubble_list_widget.dart';
import 'package:cheese_flutter/widgets/open_container.dart';
import 'package:cheese_flutter/routes/common/publish_bubble_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:cheese_flutter/routes/common/bubble_list_widget.dart';

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

  @override
  void initState() {
    super.initState();
    
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
                      // Image.network(
                      //     "${Global.BASE_URL}/images/bubble/test.jpg"),
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
          body: BubbleListWidget(requestResUrl: "/categories/${widget.categoryName}/posts")
        ));
  }


}
