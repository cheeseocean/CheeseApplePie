import 'package:cheese_flutter/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemWrapper extends StatelessWidget {
  final String avatar;
  final String name;
  final DateTime date;
  final Widget action;
  final Widget content;
  final Widget footer;
  final List<String> imageUrls;
  final double scale;
  final bool showBottomDivider;

  ItemWrapper({
    @required this.avatar,
    @required this.name,
    @required this.date,
    this.content,
    this.action,
    this.footer,
    this.imageUrls,
    this.scale = 1.0,
    this.showBottomDivider = false,
  });

  static String thumbnailSuffix = "@500w_500h_100q_r";

  static double headerHeight = 56.0;
  static double footerHeight = 40.0;
  static final defaultCrossAxisCount = 3;
  static final itemPadding = 6.0;

  var _crossAxisCount = defaultCrossAxisCount;
  var _mainAxisCount;

  //两张和四张图片的高度
  var _heightOf124 = ScreenUtil.screenWidth / 2;

  //其他数量时的高度
  var _heightOfOthers = ScreenUtil.screenWidth / 3;

  var _imageGridTotalWidth = ScreenUtil.screenWidth;
  var _imageGridTotalHeight;

  List<Widget> _children = <Widget>[];

  Widget _imageWidget(url) => ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image(
          fit: BoxFit.fill,
          image: NetworkImage("$url$thumbnailSuffix"),
        ),
      );

  @override
  Widget build(BuildContext context) {
    int imageCount = imageUrls?.length ?? 0;
    if (imageCount != 0) {
      calculateImageWidgetHeight(imageCount);
    }
    var headerWidget = SizedBox(
      height: headerHeight * scale,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Align(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                ),
              )),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${date.month}-${date.day} ${date.hour}:${date.minute}',
                  style: TextStyle(fontSize: 11.0, color: Colors.grey[600]),
                )
              ],
            ),
          ),
          Expanded(flex: 2, child: action ?? Container())
        ],
      ),
    );
    _children.add(headerWidget);
    if (content != null) {
      _children.add(content);
    }
    if (imageCount != 0) {
      _children.add(Container(
          height: _imageGridTotalHeight,
          width: _imageGridTotalWidth,
          child: buildImageGrid(imageUrls, _crossAxisCount)));
    }
    if (footer != null) {
      _children.add(SizedBox(height: footerHeight * scale, child: footer));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: itemPadding),
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(
        context,
        width: showBottomDivider ? 0.2 : 0.0,
        color: showBottomDivider ? Colors.grey : Colors.transparent
      ),)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _children),
    );
  }

  void calculateImageWidgetHeight(int imageCount) {
    var _gridItemHeight;
    switch (imageCount) {
      case 1:
      case 2:
      case 4:
        _gridItemHeight = _heightOf124;
        _crossAxisCount = 2;
        break;
      default:
        _gridItemHeight = _heightOfOthers;
        _crossAxisCount = 3;
        break;
    }
    if (imageCount % _crossAxisCount == 0)
      _mainAxisCount = imageCount ~/ _crossAxisCount;
    else
      _mainAxisCount = imageCount ~/ _crossAxisCount + 1;
    _imageGridTotalHeight = _gridItemHeight * _mainAxisCount;
  }

  Widget buildImageGrid(List<String> imageUrls, int crossAxisCount) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: imageUrls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, childAspectRatio: 1.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: Stack(
              children: [
                Positioned.fill(child: _imageWidget(imageUrls[index])),
              ],
            ),
          );
        });
  }
}
