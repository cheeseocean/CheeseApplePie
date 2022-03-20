import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 输入框样式
InputDecoration inputDecoration(labelText, hintText) {
  return InputDecoration(
    hintText: hintText,
    contentPadding: EdgeInsets.all(5.w),
    labelText: labelText,
    border: const OutlineInputBorder(),
    labelStyle: TextStyle(fontSize: 15.sp),
    hintStyle: TextStyle(fontSize: 15.sp),
  );
}

class XTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.r,
      child: TextFormField(),
    );
  }
}
