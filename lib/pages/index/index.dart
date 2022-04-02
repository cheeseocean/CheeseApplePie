import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/http.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation.dart';
import 'package:flutter_application/pages/index/index-model.dart';
import 'package:flutter_application/widgets/icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../router/router.dart';
import '../../widgets/quill.dart';
import '../../widgets/text-fields.dart';
import '../../widgets/video.dart';
import '../creation/creation-model.dart';
import 'index-params.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final ScrollController _scrollController = ScrollController();
  List<SelectPostsResModel> _items = [];
  int _totalCount = 0;
  final PostListParams _postListParams = PostListParams(pageSize: 4);

  Future _getData([bool add = false]) async {
    Response response = await dio.get(selectPostsUrl, queryParameters: _postListParams.toJson());
    setState(() {
      ResponseModel<List<SelectPostsResModel>> res = ResponseModel.fromJson(response.data, toData: SelectPostsResModel.toData);
      if (add) {
        _items.addAll(res.data!);
      } else {
        _items = res.data!;
      }
      _totalCount = res.totalCount!;
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
                return Padding(padding: EdgeInsets.only(bottom: 10.w), child: const Center(child: Text('我是有底线的')));
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
  final SelectPostsResModel post;
  final GlobalKey<_IconButtonState> _btnKey = GlobalKey();

  _Item(this.post);

  _onLike() async {
    loading.autoOpen = false;
    Response response = await dio.post(likePostUrl, data: {'postId': post.id});
    ResponseModel<LikePostResModal> res = ResponseModel.fromJson(response.data, toData: LikePostResModal.toData);
    if (res.status == 0) _btnKey.currentState!.update(res.data!.type == 1);
  }

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
                    post.username,
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
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context)
                  .pushNamed(RoutePath.postDetail, arguments: PreviewData(post.content.data, post.content.assets, post.contentType, post.fileInfos)),
              child: IgnorePointer(child: _Content(post.content))),
          alignment: Alignment.bottomLeft,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          margin: EdgeInsets.only(bottom: 8.w),
          child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: post.fileInfos.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 3.w, crossAxisSpacing: 3.w, childAspectRatio: 1),
              itemBuilder: (context, i) {
                FileInfo fileInfo = post.fileInfos[i];
                return fileInfo.type == AssetType.image
                    ? Image.network(
                        fileInfo.path,
                        fit: BoxFit.cover,
                      )
                    : SmallPlayer(fileInfo.path);
              }),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          height: 40.w,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _IconButton(
              key: _btnKey,
              icon: likeIcon,
              text: post.likes.toString(),
              onTap: _onLike,
              active: post.liked == 1,
            ),
            _IconButton(
              icon: commentIcon,
              text: post.comments.toString(),
              onTap: () {
                showModalBottomSheet(builder: (BuildContext context) => buildBottomSheetWidget(context, post), context: context);
              },
            ),
          ]),
        )
      ],
    );
  }
}

Widget buildBottomSheetWidget(BuildContext context, SelectPostsResModel post) {
  final TextEditingController _contentCtr = TextEditingController();
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.w,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _contentCtr,
                decoration: inputDecoration('', '说点啥吧'),
              )),
              SizedBox(
                width: 5.w,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      Response response = await dio.post(commentPostUrl, data: {'postId': post.id, 'parentId': null, 'content': _contentCtr.text});
                      print(response.data);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('发送'))
            ],
          ),
          SizedBox(
            height: 20.w,
          )
        ],
      ));
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;
  final bool active;

  const _IconButton({required this.icon, required this.text, required this.onTap, this.active = false, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  late int count;
  late bool active;
  late Color color;

  @override
  void initState() {
    count = int.parse(widget.text);
    active = widget.active;
    setColor();
    super.initState();
  }

  void setColor() {
    setState(() => color = active ? XColor.primary : Colors.black);
  }

  void update(bool add) {
    setState(() {
      add ? count++ : count--;
      active = add;
      setColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Icon(
            widget.icon,
            color: color,
            size: 24.sp,
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(count.toString(), style: TextStyle(fontSize: 16.sp))
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final PostContent content;

  const _Content(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = [];
    const int maxLine = 5; // 最大显示行数
    int i = 0;
    for (var element in content.data) {
      var insert = element['insert'];
      if (insert is Map) continue;
      List<String> contents = (insert as String).split('\n');
      String temp = contents.sublist(0, min(contents.length, maxLine - i)).join('\n');
      i = contents.length;
      if (i > maxLine) {
        element['insert'] = temp + '\n';
        list.add(element);
        break;
      } else {
        element['insert'] = temp;
        list.add(element);
      }
    }
    return CustomQuillEditor(
      controller: quill.QuillController(document: quill.Document.fromJson(list), selection: const TextSelection.collapsed(offset: 0)),
      scrollable: false,
      readOnly: true,
    );
  }
}
