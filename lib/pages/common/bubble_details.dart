import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page.dart';
import 'package:cheese_flutter/models/comment.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/pages/common/comment_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class BubbleDetails extends StatefulWidget {
  final Bubble bubble;

  BubbleDetails(this.bubble);

  @override
  State<StatefulWidget> createState() {
    return _BubbleDetailsState();
  }
}

class _BubbleDetailsState extends State<BubbleDetails> {
  List<Comment> _commentList = <Comment>[];

  Widget get postInfo => Container(
        child: TextField(),
      );

  Widget getItem(int index) {
    return CommentListItem(_commentList[index]);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Cheese.getCommentListOfBubble(widget.bubble.id,
              page: PageParameter(size: 6))
          .then((commentList) {
        _commentList = commentList.comments;
      }).catchError((error) {
        print(error);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('details'),
        centerTitle: true,
      ),
      body: EasyRefresh.builder(
        builder: (context, physics, header, footer) {
          return CustomScrollView(
            slivers: [
              header,
              postInfo,
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return getItem(index);
              }, childCount: _commentList.length)),
              footer,
            ],
          );
        },
        onRefresh: () async {},
        onLoad: () async {},
      ),
    );
  }
}
