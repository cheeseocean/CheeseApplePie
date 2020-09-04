import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         colors: [Colors.amber[200], Colors.lightBlue[300]])),
      child: Center(
        child: Hero(
          tag: "LOGO",
          child: Text(
            "学在南理",
            style: TextStyle(
                color: Colors.orange[800], fontFamily: "LiuJianMa", fontSize: 80, decoration: TextDecoration.none),
          ),
          // child: Image.asset("assets/images/avatar_placeholder.jpg", width: 60, height: 60,),
        ),
      ),
    );
  }
}
