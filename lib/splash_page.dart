import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'provider/providers.dart';
import 'routes/login/page/container_page.dart';
import 'routes/login/page/login_page.dart';

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
          const Duration(seconds: 1),
          () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder<void>(
                pageBuilder: (
                  BuildContext _,
                  Animation<double> __,
                  Animation<double> ___,
                ) {
                  // return _isLogin ? ContainerPage() : LoginPage();
                  return ContainerPage();
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
            "NIOT",
            style: TextStyle(
                fontFamily: "Chocolate",
                fontSize: 100.0,
                color: Colors.amber,
                decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }
}
