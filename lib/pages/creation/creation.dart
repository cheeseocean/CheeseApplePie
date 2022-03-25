import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../http/http.dart';
import 'creation-widget.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  final TextEditingController _contentCtr = TextEditingController();
  final _FormParams _formParams = _FormParams();
  List<FileInfo> _fileInfos = [];

  final Map<String, AssetType> _fieldFileMap = Map();
  final quill.QuillController _quillCtr = quill.QuillController.basic();

  // final GlobalKey<TypeRadioState> _radioKey = GlobalKey();

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
                            quill.QuillToolbar.basic(
                              controller: _quillCtr,
                              onImagePickCallback: (file) {
                                _fieldFileMap.putIfAbsent(file.path, () => AssetType.image);
                                // _quillFileInfo.add(QuillFileInfo(type: AssetType.image, path: file.path));
                                return Future.value(file.path);
                              },
                              onVideoPickCallback: (file) {
                                _fieldFileMap.putIfAbsent(file.path, () => AssetType.video);
                                // _quillFileInfo.add(QuillFileInfo(type: AssetType.video, path: file.path));
                                return Future.value(file.path);
                              },
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                child: quill.QuillEditor(
                                  controller: _quillCtr,
                                  scrollController: ScrollController(),
                                  scrollable: true,
                                  focusNode: FocusNode(),
                                  autoFocus: true,
                                  readOnly: false,
                                  expands: false,
                                  padding: const EdgeInsets.all(5),
                                  keyboardAppearance: Brightness.light,
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
                        final width = (MediaQuery.of(context).size.width - 40) / 3;
                        print(width);
                        for (AssetEntity file in files) {
                          String path = (await file.file)!.path;
                          _fileInfos.add(FileInfo(type: file.type, path: path));
                          _quillCtr.document.insert(_quillCtr.document.length - 1, quill.Embeddable.fromJson({'image': path}));
                          _quillCtr.formatText(_quillCtr.document.length - 2, 1, quill.StyleAttribute('mobileWidth: $width; mobileHeight: $width; mobileMargin: 1; mobileAlignment: center;'));
                          print(_quillCtr.document.toDelta().toJson());
                        }
                        setState(() {});
                      },
                      child: const Text('选择图片或视频'),
                    ),
                    const Text(
                      '*选择的内容将会自动插入到文本的最下方',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    PhotoAndVideoList(_fileInfos),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            List<String>? paths = await _formatContent();
                            if (paths == null) return;
                            Navigator.pushNamed(context, RoutePath.previewPost,
                                arguments: PreviewData(_quillCtr.document.toDelta().toJson(), paths, _formParams.contentType, _fileInfos));
                          },
                          child: const Text('预览'),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ElevatedButton(
                          onPressed: _onSubmit,
                          child: const Text('发布'),
                        )
                      ],
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

  Future<List<String>?> _formatContent() async {
    quill.Delta delta = _quillCtr.document.toDelta();
    if (delta.length == 0 || (delta.length == 1 && delta[0].value.toString().trim() == '') && _fileInfos.isEmpty) {
      showToast('请输入内容');
      return null;
    }
    // _formParams.contentType = _radioKey.currentState?.groupValue as String;
    List list = _quillCtr.document.toDelta().toList();
    List<String> paths = [];
    // if (_formParams.contentType == PostContentType.normal) {
    //   // 自动布局
    //   bool res = list.every((element) {
    //     var value = element.value;
    //     if (value is! Map) return true;
    //     return !(value.containsKey('image') || value.containsKey('video'));
    //   });
    //   if (!res) {
    //     showToast('自动布局方式不能在输入框中插入图片或视频哦');
    //     return null;
    //   }
    //   for (FileInfo fileInfo in _fileInfos) {
    //     paths.add(fileInfo.path);
    //   }
    // } else {
    // 自定义布局
    for (var element in list) {
      var value = element.value;
      if (value is! Map) continue;
      if (value.containsKey('image')) {
        paths.add(value['image']);
      } else if (value.containsKey('video')) {
        paths.add(value['video']);
      }
    }
    // }
    return paths;
  }

  // 发布
  void _onSubmit() async {
    List<String>? paths = await _formatContent();
    if (paths == null) return;
    _formParams.images = [];
    _formParams.videos = [];
    if (paths.isNotEmpty) {
      // 如果有文件则上传
      List<MultipartFile> assets = [];
      for (String path in paths) {
        assets.add(await MultipartFile.fromFile(path));
      }
      FormData formData = FormData.fromMap({'assets': assets});
      Response res = await dio.post(uploadUrl, data: formData);
      UploadResModel uploadResModel = UploadResModel.fromJson(res.data);
      if (uploadResModel.status != 0) return showToast(uploadResModel.message);
      int i = 0;
      for (String path in uploadResModel.data) {
        if (_fieldFileMap[path] == AssetType.image) {
          _formParams.images.add('$path?i=${i++}');
        } else {
          _formParams.videos.add('$path?i=${i++}');
        }
      }
    }
    _fieldFileMap.clear();
    _formParams.content = _quillCtr.document.toDelta().toJson().toString();
    Response res2 = await dio.post(createPostUrl, data: _formParams);
    ResponseModel responseModel = ResponseModel.fromJson(res2.data);
    Fluttertoast.showToast(msg: responseModel.message);
    if (responseModel.status == 0) Navigator.of(context).pushNamed(RoutePath.home, arguments: 1);
  }
}

class _FormParams {
  String content = '';
  List<String> images = [];
  List<String> videos = [];
  String contentType = PostContentType.quillJson;

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "contentType": contentType,
      "images": images,
      "videos": videos,
    };
  }
}
