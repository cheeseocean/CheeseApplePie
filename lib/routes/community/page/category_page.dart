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
        // backgroundColor: Theme.of(context).primaryColorLight,
        floatingActionButton: OpenContainer(
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
                ),
              ),
            );
          },
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: Colors.yellow,
                        )
                      ],
                    ),
                  ),
                  pinned: true,
                  expandedHeight: 200,
                  title: Text(widget.categoryName),
                  forceElevated: innerBoxIsScrolled,
                )
              ];
            },
            body: BubbleListWidget(
                requestResUrl: "/categories/${widget.categoryName}/posts")));
  }
}
