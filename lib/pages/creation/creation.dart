import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/widgets/quill.dart';
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
  // final TextEditingController _contentCtr = TextEditingController();
  final _FormParams _formParams = _FormParams();
  List<FileInfo> _fileInfos = [];

  final List<AssetType> _fileTypes = [];
  final quill.QuillController _quillCtr = quill.QuillController.basic();

  // final GlobalKey<TypeRadioState> _radioKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _contentCtr.addListener(() => _formParams.content = _contentCtr.text);
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
                                // _fileTypes.putIfAbsent(file.path, () => AssetType.image);
                                // _quillFileInfo.add(QuillFileInfo(type: AssetType.image, path: file.path));
                                return Future.value(file.path);
                              },
                              onVideoPickCallback: (file) {
                                // _fileTypes.putIfAbsent(file.path, () => AssetType.video);
                                // _quillFileInfo.add(QuillFileInfo(type: AssetType.video, path: file.path));
                                return Future.value(file.path);
                              },
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                child: CustomQuillEditor(controller: _quillCtr,),
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
                        // final width = (MediaQuery.of(context).size.width - 40) / 3;
                        for (AssetEntity file in files) {
                          String path = (await file.file)!.path;
                          _fileInfos.add(FileInfo(type: file.type, path: path));
                          // _fileTypes.putIfAbsent(path, () => file.type);
                          // _quillCtr.document.insert(_quillCtr.document.length - 1, quill.Embeddable.fromJson({'image': path}));
                          // _quillCtr.formatText(_quillCtr.document.length - 2, 1, quill.StyleAttribute('mobileWidth: $width; mobileHeight: $width; mobileMargin: 1; mobileAlignment: centerLeft;'));
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
    List<String> richPaths = [];
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
    //     richPaths.add(fileInfo.path);
    //   }
    // } else {
    // 自定义布局
    for (var element in list) {
      var value = element.value;
      if (value is! Map) continue;
      if (value.containsKey('image')) {
        _fileTypes.add(AssetType.image);
        richPaths.add(value['image']);
      } else if (value.containsKey('video')) {
        richPaths.add(value['video']);
        _fileTypes.add(AssetType.video);
      }
    }
    // }
    return richPaths;
  }

  // 发布
  void _onSubmit() async {
    _fileTypes.clear();
    List<String>? richPaths = await _formatContent();
    if (richPaths == null) return;
    _formParams.images = [];
    _formParams.videos = [];
    List list = _quillCtr.document.toDelta().toJson();
    if (richPaths.isNotEmpty || _fileInfos.isNotEmpty) {
      // 如果有文件则上传
      List<MultipartFile> assets = [];
      for (String path in richPaths) {
        assets.add(await MultipartFile.fromFile(path));
      }
      for (FileInfo fileInfo in _fileInfos) {
        _fileTypes.add(fileInfo.type);
        assets.add(await MultipartFile.fromFile(fileInfo.path));
      }
      FormData formData = FormData.fromMap({'assets': assets});
      Response res = await dio.post(uploadUrl, data: formData);
      UploadResModel uploadResModel = UploadResModel.fromJson(res.data);
      if (uploadResModel.status != 0) return showToast(uploadResModel.message);
      for (int i = 0; i < uploadResModel.data.length; i++) {
        if (_fileTypes[i] == AssetType.image) {
          _formParams.images.add('${uploadResModel.data[i]}?i=$i');
        } else {
          _formParams.videos.add('${uploadResModel.data[i]}?i=$i');
        }
      }
      int j = 0;
      if (richPaths.isNotEmpty) {
        for (var element in list) {
          var insert = element['insert'];
          if (insert is! Map) continue;
          if (insert.containsKey('image')) {
            insert['image'] = (j++).toString();
          } else if (insert.containsKey('video')) {
            insert['video'] = (j++).toString();
          }
        }
      }
      _formParams.content.data = list;
      _formParams.content.assets = _fileInfos.map((_) => (j++).toString()).toList();
    } else {
      _formParams.content.data = _quillCtr.document.toDelta().toList();
      // _formParams.content = _quillCtr.document.toDelta().toJson().toString();
    }
    _fileTypes.clear();
    Response res2 = await dio.post(createPostUrl, data: _formParams);
    ResponseModel responseModel = ResponseModel.fromJson(res2.data);
    Fluttertoast.showToast(msg: responseModel.message);
    if (responseModel.status == 0) NestedRouter.push(context, RoutePath.personal);
  }
}

class _FormParams {
  PostContent content = PostContent([], []);
  List<String> images = [];
  List<String> videos = [];
  String contentType = PostContentType.quillJson;

  Map<String, dynamic> toJson() {
    return {
      "content": jsonEncode(content.toJson()),
      "contentType": contentType,
      "images": images,
      "videos": videos,
    };
  }
}

class PostContent {
  List data;
  List<String> assets;

  PostContent(this.data, this.assets);

  factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      List.from(json["data"]),
      List.from(json["assets"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"data": data, "assets": assets};
  }
}
