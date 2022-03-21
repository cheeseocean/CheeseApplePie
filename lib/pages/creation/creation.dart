import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../http/http.dart';
import '../../widgets/video.dart';
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
  final quill.QuillController _quillCtr = quill.QuillController.basic();
  final GlobalKey<TypeRadioState> _radioKey = GlobalKey();

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
                              mediaPickSettingSelector: ,
                              onImagePickCallback: (file) {
                                print('dfadfffffffffffffffffffffffffffffffffffff');
                                print(file.path);
                                return Future.value(file.path);
                              },
                              // filePickImpl: (context) {
                              //   print('00000000000000000000000000000000000000000000000000000000000000000');
                              //   return Future.value('');
                              // },
                              onVideoPickCallback: (file) {
                                print('dfadfffffffffffffffffffffffffffffffffffff---video');
                                return Future.value(file.path);
                              },
                              // webVideoPickImpl: (cb) {
                              //   print('dfadfffffffffffffffffffffffffffffffffffff---video impl');
                              //   return Future.value('');
                              // },
                            ),
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
                            _fileInfos.add(FileInfo(type: file.type, file: file, path: path));
                          } else if (file.type == AssetType.video) {
                            _fileInfos.add(FileInfo(type: file.type, file: file, path: path));
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
                            FileInfo fileInfo = _fileInfos[i];
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
                                      Clipboard.setData(ClipboardData(text: 'http://$host:$port${_fileInfos[i].path}'));
                                      showToast('复制链接成功（该链接为临时地址）');
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
                    TypeRadio(
                      key: _radioKey,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        quill.Delta delta = _quillCtr.document.toDelta();
                        if (delta.length == 0 || (delta.length == 1 && delta[0].value.toString().trim() == '')) {
                          showToast('请输入内容');
                          return;
                        }
                        _formParams.contentType = _radioKey.currentState?.groupValue as String;
                        if (_formParams.contentType == PostContentType.normal) {}
                        return;
                        // final List<MultipartFile> images = [];
                        // final List<MultipartFile> videos = [];
                        // for (FileInfo fileInfo in _fileInfos) {
                        //   if (fileInfo.type == AssetType.image) {
                        //     images.add(await MultipartFile.fromFile(fileInfo.path));
                        //   } else if (fileInfo.type == AssetType.video) {
                        //     videos.add(await MultipartFile.fromFile(fileInfo.path));
                        //   }
                        // }
                        // print(images);
                        // FormData formData = FormData.fromMap({'content': _formParams.content, 'images': images, 'videos': videos});
                        // if (_formParams.content == '' && images.isEmpty && videos.isEmpty) {
                        //   Fluttertoast.showToast(msg: '请发点啥吧');
                        //   return;
                        // }
                        // Response res = await dio.post(createPostUrl, data: formData);
                        // ResponseModel responseModel = ResponseModel.fromJson(res.data);
                        // Fluttertoast.showToast(msg: responseModel.message);
                      },
                      child: const Text('发布'),
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
  String content = '';
  List<String> images = [];
  List<String> videos = [];
  String contentType = PostContentType.normal;

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "images": images,
      "videos": videos,
    };
  }
}
