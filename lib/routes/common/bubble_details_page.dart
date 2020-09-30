import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/comment.dart';
import 'package:cheese_flutter/models/errorResult.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/routes/common/item_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:oktoast/oktoast.dart';

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
  final GlobalKey _contentKey = GlobalKey();
  TextEditingController _replyController = TextEditingController();

  Widget get postInfo => ItemWrapper(
        avatar: _bubble.avatarUrl,
        name: _bubble.nickname,
        date: _bubble.createdAt,
        // action:
        //     IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: () {}),
        content: Text(
          _bubble.content,
          key: _contentKey,
          maxLines: 6,
          textAlign: TextAlign.start,
        ),

        imageUrls: _bubble.imageUrls,

        footer: IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
      );

  Widget getItem(int index) {
    Comment currentComment = _commentList[index];
    print(currentComment.toJson());
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
      content: Text(
        _bubble.content,
        maxLines: 6,
        textAlign: TextAlign.start,
      ),
      footer: Text("查看剩余${currentComment.subCommentCount}条评论"),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _bubble = widget.bubble;
    }
    Future.delayed(Duration(seconds: 2), () {
      Cheese.getCommentListOfBubble(_bubble.id,
              pageParameter: PageParameter(size: 6))
          .then((commentList) {
        setState(() {
          _commentList = commentList.content;
        });
      });
    });
  }

  void addReview() {
    if (_replyController.text.isNotEmpty) {
      Cheese.addReview(_bubble.id, _replyController.text).then((rep) {
        showToast("发布成功");
      });
    }
  }

  Widget get bottomInputWidget => Container(
        height: 44.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 5,
                child: TextField(
                  controller: _replyController,
                  decoration: InputDecoration(filled: true, hintText: "回复楼主"),
                )),
            Expanded(
              flex: 1,
              child: Container(
                child: InkWell(
                  onTap: addReview,
                  child: Center(
                    child: Text(
                      "回复",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('details'),
        actions: [Icon(Icons.more_horiz)],
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
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0)
                  return postInfo;
                else
                  return getItem(index - 1);
              }, childCount: _commentList.length + 1)),
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
