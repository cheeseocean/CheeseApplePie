import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final double topPadding = 4.0;
final double bottomPadding = 4.0;

class LabelButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Widget label;

  LabelButton({this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
        ),
        child: Container(
          // color: Colors.yellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 5, child: icon),
              Expanded(flex: 2, child: label),
            ],
          ),
        ),
      ),
    );
  }
}
