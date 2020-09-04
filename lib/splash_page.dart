import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'common/notifiers.dart';
import 'pages/container_route.dart';
import 'routes/login_route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage();

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    bool _isLogin = Provider.of<UserModel>(context, listen: false).isLogin;

    SchedulerBinding.instance.addPostFrameCallback(
      (Duration _) {
        Future<void>.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder<void>(
                pageBuilder: (
                  BuildContext _,
                  Animation<double> __,
                  Animation<double> ___,
                ) {
                  return _isLogin ? ContainerPage() : LoginRoute();
                  // return LoginRoute();
                },
                transitionsBuilder: (
                  BuildContext _,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.amber[200], Colors.lightBlue[300]])),
      child: Center(
      child: Hero(
        tag: "LOGO",
        child: Text(
          "学在南理",
          style: TextStyle(
              color: Colors.orange[800], fontFamily: "LiuJianMa", fontSize: 80, decoration: TextDecoration.none),
        ),
        // child: Image.asset("assets/images/avatar_placeholder.jpg", width: 80, height: 80,),
      ),
      ),
    );
  }
}
