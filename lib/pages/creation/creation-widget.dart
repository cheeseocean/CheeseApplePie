import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/widgets/video.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../common/consts.dart';

class Gallery extends StatelessWidget {
  final List<FileInfo> _items;
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
              FileInfo fileInfo = _items[index];
              return fileInfo.type == AssetType.image
                  ? PhotoViewGalleryPageOptions(
                      imageProvider: FileImage(File(_items[index].path)),
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
              child: SizedBox(
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

class TypeRadio extends StatefulWidget {
  const TypeRadio({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TypeRadioState();
}

class TypeRadioState extends State<TypeRadio> {
  late String groupValue;

  @override
  void initState() {
    groupValue = PostContentType.normal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 40.w,
            ),
            Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: PostContentType.rich,
                groupValue: groupValue,
                onChanged: (String? value) => setState(() => groupValue = PostContentType.rich)),
            const Text('富文本格式（输入框中的布局）')
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 40.w,
            ),
            Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: PostContentType.normal,
                groupValue: groupValue,
                onChanged: (String? value) => setState(() => groupValue = PostContentType.normal)),
            const Text('普通文本格式（自动布局）')
          ],
        )
      ],
    );
  }
}

class PhotoAndVideoList extends StatefulWidget {
  final List<FileInfo> fileInfos;
  final bool adapt; // 是否根据图片数量调整列数
  final bool readonly;

  const PhotoAndVideoList(this.fileInfos, {this.adapt = true, this.readonly = false, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoAndVideoListState();
}

class _PhotoAndVideoListState extends State<PhotoAndVideoList> {
  SliverGridDelegateWithFixedCrossAxisCount _gridControl(int length, bool adapt) {
    if (!adapt) {
      return widget.fileInfos.isNotEmpty
          ? SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 3.w, crossAxisSpacing: 3.w, childAspectRatio: 1)
          : const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1);
    }
    int crossAxisCount = 1;
    double mainAxisSpacing = 3.w;
    double crossAxisSpacing = 3.w;
    double childAspectRatio = 1;
    if (length == 0) {
      mainAxisSpacing = crossAxisSpacing = 0;
    } else if (length == 1) {
      childAspectRatio = 16 / 9;
    } else if (length >= 2 && length <= 4) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, mainAxisSpacing: mainAxisSpacing, crossAxisSpacing: crossAxisSpacing, childAspectRatio: childAspectRatio);
  }

  void _showGallery(BuildContext context, int i) {
    Timer(const Duration(milliseconds: 10), () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Gallery(widget.fileInfos, i))));
  }

  @override
  Widget build(BuildContext context) {
    List<FileInfo> fileInfos = widget.fileInfos;
    final bool readonly = widget.readonly;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fileInfos.length,
          gridDelegate: _gridControl(fileInfos.length, widget.adapt),
          itemBuilder: (context, i) {
            FileInfo fileInfo = fileInfos[i];
            Widget widget = fileInfo.type == AssetType.image
                ? fileInfo.path.startsWith('http')
                    ? Image.network(
                        fileInfo.path,
                        fit: BoxFit.cover,
                      )
                    : Image.file(File(fileInfo.path), fit: BoxFit.cover)
                : SmallPlayer(fileInfo.path, key: ValueKey(fileInfo.path));
            return GestureDetector(
              onTap: () {
                if (readonly) _showGallery(context, i);
              },
              child: Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
                widget,
                if (!readonly) Container(decoration: const BoxDecoration(color: Color(0x33000000))),
                if (!readonly)
                  PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) => [
                      // PopupMenuItem(
                      //   height: 30.w,
                      //   onTap: () {
                      //     Clipboard.setData(ClipboardData(text: 'http://$host:$port${fileInfos[i].path}'));
                      //     showToast('复制链接成功（该链接为临时地址）');
                      //   },
                      //   child: Text(
                      //     '复制链接',
                      //     style: TextStyle(color: XColor.primary),
                      //   ),
                      // ),
                      PopupMenuItem(
                        height: 30.w,
                        onTap: () => _showGallery(context, i),
                        child: Text('查看大图', style: TextStyle(color: XColor.primary)),
                      ),
                      PopupMenuItem(
                        height: 30.w,
                        onTap: () => setState(() => fileInfos.removeAt(i)),
                        child: Text('删除图片', style: TextStyle(color: XColor.primary)),
                      ),
                    ],
                  ),
              ]),
            );
          }),
    );
  }
}
