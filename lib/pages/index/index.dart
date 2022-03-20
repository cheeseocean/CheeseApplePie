import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/http.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/pages/index/index-model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/video.dart';
import 'index-params.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputCtr = TextEditingController(text: '');
  List<Post> _items = [];
  int _totalCount = 0;
  final PostListParams _postListParams = PostListParams(pageSize: 4);

  Future _getData([bool add = false]) async {
    Response res = await dio.get(selectPostsUrl, queryParameters: _postListParams.toJson());
    setState(() {
      SelectPostsResModel selectPostsResModel = SelectPostsResModel.fromJson(res.data);
      if (add) {
        _items.addAll(selectPostsResModel.data);
      } else {
        _items = selectPostsResModel.data;
      }
      _totalCount = selectPostsResModel.totalCount;
    });
    return Future.value();
  }

  Future<void> _onRefresh() async {
    _postListParams.pageIndex = 1;
    await _getData();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(throttle(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 20 && _items.length < _totalCount) {
        _postListParams.pageIndex++;
        _getData(true);
      }
    }));
    _getData();
    _inputCtr.addListener(() {
      print(_inputCtr.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          padding: EdgeInsets.only(top: 35.h),
          controller: _scrollController,
          //列表滑动到边界时，显示iOS的弹出效果
          physics: const BouncingScrollPhysics(),
          itemCount: _items.length + 1,
          itemBuilder: (context, index) {
            if (index == _items.length) {
              if (_items.length < _totalCount) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                );
              } else {
                return Padding(padding: EdgeInsets.only(bottom: 10.w), child: Center(child: const Text('我是有底线的')));
              }
            } else {
              return _Item(_items[index]);
            }
          },
          //分割构造器
          separatorBuilder: (context, index) {
            return Divider(
              indent: 8.w,
              endIndent: 8.w,
              color: Colors.blue,
            );
          },
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  Post post;

  _Item(this.post);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.w,
              ),
              Icon(
                Icons.people_outline_outlined,
                size: 45.w,
                color: Colors.blue,
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '呢称',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  Text(
                    post.createdAt,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          child: Text(
            post.content,
            style: TextStyle(fontSize: 14.sp),
          ),
          alignment: Alignment.bottomLeft,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          margin: EdgeInsets.only(bottom: 8.w),
          child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: post.imageList.length + post.videoList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 3.w, crossAxisSpacing: 3.w, childAspectRatio: 1),
              itemBuilder: (context, i) {
                return i < post.imageList.length
                    ? Image.network(
                        'http://$host:$port/${post.imageList[i]}',
                        fit: BoxFit.cover,
                      )
                    : SmallPlayer('http://$host:$port/${post.videoList[i - post.imageList.length]}');
              }),
        )
      ],
    );
  }
}
