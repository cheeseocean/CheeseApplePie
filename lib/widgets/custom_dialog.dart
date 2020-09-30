import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;
  final String leftButtonLabel;
  final String rightButtonLabel;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final Widget content;

  CustomDialog(
      {this.title,
      this.leftButtonLabel,
      this.rightButtonLabel,
      @required this.content,
      this.onLeftPressed,
      this.onRightPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Center(child: Text(title)),
      title: title ?? Container(),
      scrollable: true,
      titlePadding: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0),
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: content,
      actions: [
        Container(
          width: 280.0,
          height: 45.0,
          child: Column(
            children: [
              Divider(
                height: 2.0,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: onLeftPressed,
                        child: Text(leftButtonLabel),
                      ),
                    ),
                    VerticalDivider(
                      width: 2.0,
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: onRightPressed,
                        child: Text(rightButtonLabel),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
