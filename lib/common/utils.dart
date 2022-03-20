import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    webPosition: 'center',
    gravity: ToastGravity.CENTER,
  );
}

class Loading {
  bool _closed = true;
  bool autoOpen = true; // 是否在发请求时自动开启loading
  bool _manual = false; // 是否手动关闭loading

  open({manual = false, status = '加载中...'}) {
    // EasyLoading.show(status: status, maskType: EasyLoadingMaskType.black);
    Fluttertoast.showToast(
      msg: "加载中...",
      webPosition: 'center',
      gravity: ToastGravity.CENTER,
    );
    _closed = false;
    _manual = manual;
  }

  close() {
    // EasyLoading.dismiss();
    // Fluttertoast.cancel();
    _closed = true;
    _manual = false;
    autoOpen = true;
  }

  bool get closed => _closed;

  bool get manual => _manual;
}

// 节流
Function() throttle(Function() cb, [milliseconds = 300]) {
  bool flag = false;
  return () {
    if (flag) return;
    flag = true;
    cb();
    Timer(Duration(milliseconds: milliseconds), () => flag = false);
  };
}
