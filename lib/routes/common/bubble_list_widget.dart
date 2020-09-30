import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/widgets/open_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';

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

class _BubbleListWidgetState extends State<BubbleListWidget>
    with AutomaticKeepAliveClientMixin {
  Widget get bubbleAction => FlatButton(
        onPressed: () {},
        child: Icon(Icons.expand_more_rounded),
      );
  List<Bubble> _bubbleList = <Bubble>[];

  num _pageSize = DEFAULT_PAGE_SIZE;
  num _nextPageNumber = DEFAULT_PAGE_NUMBER;

  @override
  void initState() {
    super.initState();
    print("init bubble list");
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter: PageParameter(size: _pageSize))
            .then((bubbleList) {
          setState(() {
            _bubbleList = bubbleList.content;
          });
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter: PageParameter(
                    start: _bubbleList[0].createdAt, size: _pageSize))
            .then((value) {
          if (value.content != null || value.content.isNotEmpty) {
            setState(() {
              _bubbleList.insertAll(0, value.content);
            });
          }
        });
      }
    });
  }

  Future<void> _onLoadMore() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        print("pageNumber: $_nextPageNumber");
        Cheese.getBubbleList(widget.requestResUrl,
                pageParameter: PageParameter(
                    end: _bubbleList[_bubbleList.length - 1].createdAt,
                    size: _pageSize))
            .then((bubbleList) {
          if (bubbleList.content != null || bubbleList.content.isNotEmpty) {
            setState(() {
              _bubbleList.addAll(bubbleList.content);
              _nextPageNumber++;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Builder(
        builder: (context) {
          return EasyRefresh(
            header: CustomHeader(
                enableInfiniteRefresh: false,
                extent: 40.0,
                triggerDistance: 50.0,
                headerBuilder: (context,
                    loadState,
                    pulledExtent,
                    loadTriggerPullDistance,
                    loadIndicatorExtent,
                    axisDirection,
                    float,
                    completeDuration,
                    enableInfiniteLoad,
                    success,
                    noMore) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: SpinKitCircle(
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            footer:CustomFooter(
                enableInfiniteLoad: false,
                extent: 40.0,
                triggerDistance: 50.0,
                footerBuilder: (context,
                    loadState,
                    pulledExtent,
                    loadTriggerPullDistance,
                    loadIndicatorExtent,
                    axisDirection,
                    float,
                    completeDuration,
                    enableInfiniteLoad,
                    success,
                    noMore) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: SpinKitCircle(
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            onRefresh: _onRefresh,
            onLoad: _onLoadMore,
            child: ListView.separated(
                // padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                separatorBuilder: (_, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return getItem(_bubbleList[index]);
                  // return Container(height: (index + 1) * 20.0, color: Colors.blue, child: Text("test"),);
                },
                itemCount: _bubbleList.length),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getItem(Bubble bubble) {
    // return BubbleListItem(bubble: bubble);
    return OpenContainer(
      closedColor: Theme.of(context).canvasColor,
      closedElevation: 0.0,
      closedBuilder: (context, openContainer) {
        return ItemWrapper(
            avatar: bubble.avatarUrl,
            name: bubble.nickname,
            date: bubble.createdAt,
            action: bubbleAction,
            content: Text(
              bubble.content,
              maxLines: 6,
              style: TextStyle(fontSize: 16, wordSpacing: 1.0),
              textAlign: TextAlign.start,
            ),
            imageUrls: bubble.imageUrls,
            footer: footer);
      },
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) {
        return BubbleDetailsPage(bubble);
      },
    );
  }

  Widget get footer => Container(
        // color: Colors.yellow,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: LikeButton(likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.messenger_rounded,
                    color: Colors.grey[700],
                    size: 18.0,
                  );
                })),
            Expanded(
                flex: 1,
                child: LikeButton(
                    circleColor:
                        CircleColor(start: Colors.red, end: Colors.red),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Colors.red,
                      dotSecondaryColor: Colors.red,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey[700],
                        size: 18.0,
                      );
                    })),
          ],
        ),
      );
}
