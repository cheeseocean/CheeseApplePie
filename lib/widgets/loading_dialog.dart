import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {

  final LoadingType type;
  final Color color;
  final double size;
  final Duration duration;

  LoadingDialog({this.type, this.color, this.size, this.duration});

  @override
  Widget build(BuildContext context) {
    Widget animation;
    switch (type) {
      case LoadingType.circle:
        animation = SpinKitCircle(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      case LoadingType.cubeGrid:
        animation = SpinKitCubeGrid(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      case LoadingType.fadingCube:
        animation = SpinKitFadingCube(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      case LoadingType.threeBounce:
        animation = SpinKitThreeBounce(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      case LoadingType.wave:
        animation = SpinKitWave(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      case LoadingType.fadingGrid:
        animation = SpinKitFadingGrid(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
      default:
        animation = SpinKitFadingCube(size: size ?? 30.0,
          color: color ?? Colors.blue,
          duration: duration ?? Duration(milliseconds: 1400),);
        break;
    }
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

enum LoadingType {
  wave,
  fadingCube,
  circle,
  cubeGrid,
  threeBounce,
  fadingGrid,
}
