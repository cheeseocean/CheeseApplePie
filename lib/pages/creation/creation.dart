import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/widgets/text-fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../http/http.dart';
import '../../widgets/video.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  final TextEditingController _contentCtr = TextEditingController();
  final _FormParams _formParams = _FormParams(content: '', images: [], videos: []);
  List<_FileInfo> _fileInfos = [];
  final quill.QuillController _quillCtr = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _contentCtr.addListener(() => _formParams.content = _contentCtr.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: MediaQueryData.fromWindow(window).padding.top,
          ),
          Expanded(
            child: ListView(children: [
              IntrinsicWidth(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: SizedBox(
                        height: 300.h,
                        child: Column(
                          children: [
                            quill.QuillToolbar.basic(controller: _quillCtr),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                child: quill.QuillEditor.basic(
                                  controller: _quillCtr,
                                  readOnly: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        List<AssetEntity>? files = await AssetPicker.pickAssets(context);
                        if (files == null) return;
                        _fileInfos = [];
                        for (AssetEntity file in files) {
                          String path = (await file.file)!.path;
                          if (file.type == AssetType.image) {
                            _fileInfos.add(_FileInfo(type: file.type, file: file, path: path));
                          } else if (file.type == AssetType.video) {
                            _fileInfos.add(_FileInfo(type: file.type, file: file, path: path));
                          }
                        }
                        setState(() {});
                      },
                      child: const Text('选择图片'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _fileInfos.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, mainAxisSpacing: 3.w, crossAxisSpacing: 3.w, childAspectRatio: 1),
                          itemBuilder: (context, i) {
                            _FileInfo fileInfo = _fileInfos[i];
                            Widget widget = fileInfo.type == AssetType.image
                                ? Image(
                                    image: AssetEntityImageProvider(fileInfo.file as AssetEntity, isOriginal: false),
                                    fit: BoxFit.cover,
                                  )
                                : SmallPlayer(
                                    fileInfo.path,
                                    key: ValueKey(fileInfo.path),
                                  );
                            return Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
                              widget,
                              Container(decoration: const BoxDecoration(color: Color(0x33000000))),
                              PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    height: 30.w,
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: 'http://$host:$port'));
                                      showToast('复制链接成功');
                                    },
                                    child: Text(
                                      '复制链接',
                                      style: TextStyle(color: XColor.primary),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 30.w,
                                    onTap: () {
                                      Timer(const Duration(milliseconds: 10),
                                          () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Gallery(_fileInfos, i))));
                                    },
                                    child: Text('查看大图', style: TextStyle(color: XColor.primary)),
                                  ),
                                  PopupMenuItem(
                                    height: 30.w,
                                    onTap: () => setState(() => _fileInfos.removeAt(i)),
                                    child: Text('删除图片', style: TextStyle(color: XColor.primary)),
                                  ),
                                ],
                              ),
                            ]);
                          }),
                    ),
                    // Gallery(_fileInfos),
                    ElevatedButton(
                      onPressed: () async {
                        quill.Delta delta = _quillCtr.document.toDelta();
                        if (delta.length == 0 || (delta.length == 1 && delta[0].value.toString().trim() == '')) {
                          showToast('请输入内容');
                          return;
                        }
                        return;
                        final List<MultipartFile> images = [];
                        final List<MultipartFile> videos = [];
                        for (_FileInfo fileInfo in _fileInfos) {
                          if (fileInfo.type == AssetType.image) {
                            images.add(await MultipartFile.fromFile(fileInfo.path));
                          } else if (fileInfo.type == AssetType.video) {
                            videos.add(await MultipartFile.fromFile(fileInfo.path));
                          }
                        }
                        print(images);
                        FormData formData = FormData.fromMap({'content': _formParams.content, 'images': images, 'videos': videos});
                        if (_formParams.content == '' && images.isEmpty && videos.isEmpty) {
                          Fluttertoast.showToast(msg: '请发点啥吧');
                          return;
                        }
                        Response res = await dio.post(createPostUrl, data: formData);
                        ResponseModel responseModel = ResponseModel.fromJson(res.data);
                        Fluttertoast.showToast(msg: responseModel.message);
                      },
                      child: const Text('提交'),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _FormParams {
  String content;
  List<AssetEntity> images;
  List<AssetEntity> videos;

  _FormParams({required this.content, required this.images, required this.videos});

  Map<String, dynamic> toJson() {
    return {
      "content": content,
    };
  }
}

class _FileInfo {
  AssetType type;
  AssetEntity? file;
  String path;

  _FileInfo({required this.type, this.file, required this.path});
}

class Gallery extends StatelessWidget {
  final List<_FileInfo> _items;
  final int _index;
  late List<GlobalKey?> _videoKeys;
  late int _curIndex;

  Gallery(this._items, this._index, {Key? key}) : super(key: key) {
    _videoKeys = List.filled(_items.length, null);
    _curIndex = _index;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].type == AssetType.video) {
        _videoKeys[i] = GlobalKey();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              _FileInfo fileInfo = _items[index];
              return fileInfo.type == AssetType.image
                  ? PhotoViewGalleryPageOptions(
                      imageProvider: AssetEntityImageProvider(_items[index].file as AssetEntity, isOriginal: false),
                      heroAttributes: PhotoViewHeroAttributes(tag: _items[index].path),
                    )
                  : PhotoViewGalleryPageOptions.customChild(
                      child: NormalPlayer(
                      fileInfo.path,
                      key: _videoKeys[index],
                    ));
            },
            itemCount: _items.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            pageController: PageController(initialPage: _index),
            onPageChanged: (i) {
              (_videoKeys[_curIndex]!.currentState as NormalPlayerState).pause();
              _curIndex = i;
            },
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}
