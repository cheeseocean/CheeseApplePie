import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/quill.dart';
import '../creation/creation-model.dart';
import '../creation/creation-widget.dart';

class PostDetail extends StatelessWidget {
  PostDetail({Key? key}) : super(key: key);
  late quill.QuillController _quillCtr;

  @override
  Widget build(BuildContext context) {
    Object? previewData = ModalRoute.of(context)?.settings.arguments;
    if (previewData is! PreviewData) return const Text('暂无内容！');
    _quillCtr = quill.QuillController(document: quill.Document.fromJson(previewData.data), selection: const TextSelection.collapsed(offset: 0));
    return Scaffold(
      appBar: AppBar(
        title: const Text('详情'),
      ),
      body: Column(
        children: [
          CustomQuillEditor(controller: _quillCtr, readOnly: true),
          SizedBox(height: 5.w),
          PhotoAndVideoList(previewData.fileInfos, readonly: true)
        ],
      ),
    );
  }
}
