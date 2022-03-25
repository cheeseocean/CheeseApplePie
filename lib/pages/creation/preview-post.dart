import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/pages/creation/creation-widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewPostPage extends StatelessWidget {
  PreviewPostPage({Key? key}) : super(key: key);
  late quill.QuillController _quillCtr;

  @override
  Widget build(BuildContext context) {
    Object? previewData = ModalRoute.of(context)?.settings.arguments;
    if (previewData is! PreviewData) return const Text('暂无内容！');
    print(previewData.data);
    print(previewData.richPaths);
    print(previewData.fileInfos);
    if (previewData.contentType == PostContentType.normal) {
      // previewData.paths
    }
    _quillCtr = quill.QuillController(document: quill.Document.fromJson(previewData.data), selection: const TextSelection.collapsed(offset: 0));
    return Scaffold(
      appBar: AppBar(
        title: const Text('预览'),
      ),
      body: Container(
        child: Column(
          children: [
            quill.QuillEditor.basic(
              controller: _quillCtr,
              readOnly: true,
            ),
            SizedBox(height: 5.w),
            PhotoAndVideoList(previewData.fileInfos)
          ],
        ),
      ),
    );
  }
}
