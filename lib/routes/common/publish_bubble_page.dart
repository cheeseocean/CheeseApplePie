import 'dart:collection';
import 'dart:io';

import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../constants/extensions.dart';

const Color themeColor = Color(0xff00bc56);

class PublishBubblePage extends StatefulWidget {
  final String fromCategory;

  PublishBubblePage({this.fromCategory});

  @override
  State<StatefulWidget> createState() {
    return _PublishBubblePageState();
  }
}

class _PublishBubblePageState extends State<PublishBubblePage> {
  TextEditingController _contentEditorController = TextEditingController();

  int _selectedImages = 0;
  int _maxImages = 9;
  List<AssetEntity> images = <AssetEntity>[];

  @override
  void initState() {
    super.initState();
  }

  void _publishBubble() {
    if (_contentEditorController.text.length == 0) {
      showToast("请输入内容");
      return;
    }

    var jsonString =
        '{\"category\":\"${widget.fromCategory}\", \"content\":\"${_contentEditorController.text}\"}';
    print(jsonString);
    MultipartFile metaData = MultipartFile.fromString(jsonString,
        contentType: MediaType.parse("application/json"));
    Map<String, String> fileMappings = LinkedHashMap();

    getFilePaths().then((filePaths) {
      images.forEach((image) {
        int index = images.indexOf(image);
        fileMappings.putIfAbsent(
            filePaths[index], () => _buildImageName(index));
      });
      fileMappings.forEach((key, value) {
        print("file path: $key - filename: $value");
      });
      Cheese.publishBubble(metaData, fileMappings: fileMappings).then((value) {
        print(value.toJson());
        showToast("发布成功");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    });
  }

  Future<List<String>> getFilePaths() async {
    List<String> filePaths = List();
    // images.forEach((image) {
    //   image.file.then((file) {
    //     filePaths.add(file.path);
    //   });
    // });
    for (int i = 0; i < images.length; ++i) {
      File file = await images[i].file;
      print(file.path);
      filePaths.add(file.path);
    }
    print("getFilePaths");
    print(filePaths);
    return filePaths;
  }

  String _buildImageName(int index) {
    num timestamp = DateTime.now().millisecondsSinceEpoch;
    return "${Global.profile.user.username}_bubble_${timestamp}_$index.jpg";
  }

  ThemeData get currentTheme => context.themeData;

  Widget _selectedImageWidget(int index) {
    final AssetEntity asset = images.elementAt(index);
    return GestureDetector(
      onTap: () async {
        final List<AssetEntity> result = await AssetPickerViewer.pushToViewer(
          context,
          currentIndex: index,
          assets: images,
          themeData: AssetPicker.themeData(themeColor),
        );
        if (result != images && result != null) {
          images = List<AssetEntity>.from(result);
          if (mounted) {
            setState(() {});
          }
        }
      },
      child: RepaintBoundary(
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(8.0),
          child: _assetWidgetBuilder(asset),
        ),
      ),
    );
  }

  Widget _assetWidgetBuilder(AssetEntity asset) {
    Widget widget;
    switch (asset.type) {
      case AssetType.audio:
        widget = _audioAssetWidget(asset);
        break;
      case AssetType.video:
        widget = _videoAssetWidget(asset);
        break;
      case AssetType.image:
      case AssetType.other:
        widget = _imageAssetWidget(asset);
        break;
    }
    return widget;
  }

  Widget _audioAssetWidget(AssetEntity asset) {
    return ColoredBox(
      color: context.themeData.dividerColor,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Center(
              child: Icon(
                Icons.audiotrack,
                size: 16.0,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            left: 0.0,
            right: 0.0,
            bottom: -20.0,
            height: 20.0,
            child: Text(
              asset.title,
              style: const TextStyle(
                height: 1.0,
                fontSize: 10.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoAssetWidget(AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _imageAssetWidget(asset)),
        ColoredBox(
          color: context.themeData.dividerColor.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.video_library,
              color: Colors.white,
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget get contentEditor => TextField(
        // autofocus: true,
        showCursor: true,
        controller: _contentEditorController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "分享你的心情",
          hintStyle: TextStyle(fontWeight: FontWeight.w200),
          contentPadding: EdgeInsets.all(3.0),
          // contentPadding: EdgeInsets.only(bottom: 60, top: 0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none)),
        ),
        maxLines: 7,
      );

  Widget get publishButton => Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
              onPressed: _publishBubble,
              child: Text(
                "发布",
                style: TextStyle(fontSize: 16.0, color: Colors.blue[400]),
              )
              // label: Text("hello"),
              ),
        ),
      );

  Widget _imageAssetWidget(AssetEntity asset) {
    return Image(
      image: AssetEntityImageProvider(asset, isOriginal: false),
      fit: BoxFit.cover,
    );
  }

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          images.remove(images.elementAt(index));
          _selectedImages = images.length;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: currentTheme.canvasColor.withOpacity(0.5),
        ),
        child: Icon(
          Icons.close,
          color: currentTheme.iconTheme.color,
          size: 18.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        actions: [
          publishButton,
        ],
      ),
      body: Container(
        // height: 600,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            contentEditor,
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: images.length == 0
                    ? 1
                    : images.length == 9 ? 9 : images.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.0),
                itemBuilder: (context, index) {
                  if (index == _selectedImages) {
                    print(index);
                    return InkWell(
                      customBorder: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.solid, color: Colors.grey, width: 2.0)),
                      onTap: () async {
                        final List<AssetEntity> result =
                            await AssetPicker.pickAssets(context,
                                pageSize: 100,
                                maxAssets: _maxImages,
                                selectedAssets: images,
                                requestType: RequestType.image);
                        if (result != null && result != images) {
                          images = List<AssetEntity>.from(result);
                          _selectedImages = images.length;
                          print(_selectedImages);
                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                      child: Icon(Icons.add_a_photo_rounded),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(0.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: [
                          Positioned.fill(child: _selectedImageWidget(index)),
                          Positioned(
                            top: 6.0,
                            right: 6.0,
                            child: _selectedAssetDeleteButton(index),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
