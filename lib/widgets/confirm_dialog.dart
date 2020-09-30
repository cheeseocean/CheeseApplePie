import 'package:cheese_flutter/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({@required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      // title: hint,
      leftButtonLabel: "取消",
      rightButtonLabel: "确定",
      onLeftPressed: () {
        Navigator.of(context).pop(false);
      },
      onRightPressed: () {
        Navigator.of(context).pop(true);
      },
      content: Center(child: Text(hint)),
    );
  }
}
