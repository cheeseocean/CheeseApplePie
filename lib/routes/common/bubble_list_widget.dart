import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/widgets/open_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'bubble_details_page.dart';
import 'item_wrapper.dart';

const int DEFAULT_PAGE_SIZE = 5;
const int DEFAULT_PAGE_NUMBER = 0;

class BubbleListWidget extends StatefulWidget {
  final String requestResUrl;

  BubbleListWidget({@required this.requestResUrl});

  @override
  State<StatefulWidget> createState() {
    return _BubbleListWidgetState();
  }
}

class _BubbleListWidgetState extends State<BubbleListWidget> {
  Widget get bubbleAction =>
      FlatButton(onPressed: () {}, child: Icon(Icons.arrow_drop_down));
  List<Bubble> _bubbleList = <Bubble>[];

  num _pageSize = DEFAULT_PAGE_SIZE;
  num _nextPageNumber = DEFAULT_PAGE_NUMBER;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter:
                    PageParameter(size: _pageSize))
            .then((bubbleList) {
          print(bubbleList.content);
          setState(() {
            _bubbleList = bubbleList.content;
          });
        }).catchError((error) {
          print(error.response.data);
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter: PageParameter(
                    after: _bubbleList[0].createdAt, size: _pageSize))
            .then((value) {
          if (value.content != null || value.content.isNotEmpty) {
            setState(() {
              _bubbleList.insertAll(0, value.content);
            });
          }
        }).catchError((error) => print(error.response.data));
      }
    });
  }

  Future<void> _onLoadMore() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        print("pageNumber: $_nextPageNumber");
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter: PageParameter(
                    before: _bubbleList[_bubbleList.length - 1].createdAt,
                    size: _pageSize))
            .then((bubbleList) {
          if (bubbleList.content != null || bubbleList.content.isNotEmpty) {
            setState(() {
              _bubbleList.addAll(bubbleList.content);
              _nextPageNumber++;
            });
          }
        }).catchError((error) {
          print(error.response);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Builder(
        builder: (context) {
          return EasyRefresh(
              header: BallPulseHeader(),
              footer: BallPulseFooter(),
              onRefresh: _onRefresh,
              onLoad: _onLoadMore,
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return getItem(_bubbleList[index]);
                  },
                  itemCount: _bubbleList.length));
        },
      ),
    );
  }

  Widget getItem(Bubble bubble) {
    // return BubbleListItem(bubble: bubble);
    return OpenContainer(
      closedBuilder: (context, openContainer) {
        return ItemWrapper(
          avatar: bubble.avatarUrl,
          name: bubble.nickname,
          date: bubble.createdAt,
          action: bubbleAction,
          content: Text(bubble.content),
          bottomSpace: IconButton(
            onPressed: () {},
            icon: Icon(Icons.comment),
          ),
        );
      },
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) {
        return BubbleDetailsPage(bubble);
      },
    );
  }
}
