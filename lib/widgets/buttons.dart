
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EllipseButton extends StatelessWidget{
  final Color color;
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  EllipseButton({this.width, this.height, this.color, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 46,
      child: RaisedButton(
        color: this.color,
        child: child,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        onPressed: this.onPressed,
      ));   
  }
}