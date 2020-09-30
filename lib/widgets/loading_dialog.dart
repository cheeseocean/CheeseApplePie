import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {

  final Future<Object> callback;
  LoadingDialog({this.callback});

  @override
  Widget build(BuildContext context) {

    return UnconstrainedBox(
      constrainedAxis: Axis.vertical,
      child: SizedBox(
        width: 140.0,
        // height: 120,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          // title: Text("加载中"),
          content: SizedBox(
            height: 140.0,
            child: SpinKitFadingCube(
              size: 30.0,
              color: Colors.lightBlue,
              duration: Duration(milliseconds: 1400),
            ),
          ),
        ),
      ),
    );
  }
}
