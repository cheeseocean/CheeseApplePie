import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';

quill.DefaultStyles quillCustomStyles = quill.DefaultStyles(
    small: TextStyle(fontSize: 14.sp),
    sizeSmall: TextStyle(fontSize: 14.sp),
    paragraph:
    quill.DefaultTextBlockStyle(TextStyle(fontSize: 14.sp, color: Colors.black), const Tuple2(2, 0), const Tuple2(0, 0), const BoxDecoration()));


class CustomQuillEditor extends StatelessWidget {
  quill.QuillController controller;
  bool scrollable;
  bool readOnly;

  CustomQuillEditor({Key? key, required this.controller, this.scrollable = true, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return quill.QuillEditor(
      controller: controller,
      scrollController: ScrollController(),
      scrollable: scrollable,
      focusNode: FocusNode(),
      autoFocus: true,
      readOnly: readOnly,
      expands: false,
      padding: const EdgeInsets.all(5),
      keyboardAppearance: Brightness.light,
      customStyles: quillCustomStyles,
    );
  }
}
