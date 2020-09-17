import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/comment.dart';
import 'package:cheese_flutter/models/errorResult.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/common/item_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class BubbleDetailsPage extends StatefulWidget {
  final Bubble bubble;

  BubbleDetailsPage(this.bubble);

  @override
  State<StatefulWidget> createState() {
    return _BubbleDetailsPageState();
  }
}

class _BubbleDetailsPageState extends State<BubbleDetailsPage> {
  List<Comment> _commentList = <Comment>[];
  Bubble _bubble;

  Widget get postInfo => SliverFixedExtentList(
      delegate: new SliverChildBuilderDelegate((context, index) {
        return ItemWrapper(
          avatar: _bubble.avatarUrl,
          name: _bubble.nickname,
          date: _bubble.createdAt,
          action:
              IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: () {}),
          content: Text(_bubble.content),
          bottomSpace: IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
        );
      }, childCount: 1),
      itemExtent: 300);

  Widget getItem(int index) {
    Comment currentComment = _commentList[index];
    return ItemWrapper(
      avatar: currentComment.avatarUrl,
      name: currentComment.nickname,
      date: currentComment.createdAt,
      action: IconButton(
        icon: Icon(
          Icons.thumb_up,
        ),
        onPressed: () {},
      ),
      content: Text(currentComment.content),
      bottomSpace: Text("查看剩余${currentComment.subCommentCount}条评论"),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _bubble = widget.bubble;
    }
    Future.delayed(Duration(seconds: 2), () {
      print("get comments");
      Cheese.getCommentListOfBubble(widget.bubble.id,
              pageParameter: PageParameter(size: 6))
          .then((commentList) {
        print("get comment success");
        _commentList = commentList.comments;
      }).catchError((error) {
        print("get comment error");
        print(error.response.data);
      });
    });
  }

  Widget get bottomInputWidget => Container(
        child: Row(
          children: [
            Expanded(flex: 8, child: TextField()),
            Expanded(
                flex: 2,
                child: FlatButton(
                    onPressed: () {
                      print("submit taped");
                    },
                    child: Text("回复")))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('details'),
        centerTitle: true,
      ),
      bottomSheet: BottomSheet(
        onClosing: () {}, //TODO: bottom sheet
        builder: (context) {
          return bottomInputWidget;
        },
      ),
      body: EasyRefresh.builder(
        builder: (context, physics, header, footer) {
          return CustomScrollView(
            physics: physics,
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
