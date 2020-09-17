import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/routes/login/page/container_page.dart';
import 'package:cheese_flutter/splash_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'common/global.dart';
import 'routes/login/page/login_page.dart';
import 'routes/login/page/register_page.dart';
import 'package:flutter/scheduler.dart';

import 'routes/not_found_page.dart';
import 'routes/routers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //初始化用户数据,如果无则登入
  Global.init().then((e) => runApp(MyApp())).catchError((e) => print(e));

  // runApp(MyApp());
  print("runMyApp");
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  AssetPicker.registerObserve();
}

class MyApp extends StatelessWidget {

  final Widget home;
  final ThemeData theme;

  MyApp({this.home, this.theme});
  @override
  Widget build(BuildContext context) {
    print("MyApp build");
    return OKToast(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: UserProvider()),
            ChangeNotifierProvider.value(value: ThemeProvider())
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                theme: theme ?? provider.getTheme(),
                darkTheme: provider.getTheme(isDarkMode: true),
                themeMode: provider.getThemeMode(),
                home: const SplashPage(),
                //注册fluro Router
                onGenerateRoute: Routers.router.generator,
                builder: (BuildContext c, Widget w) {
                  return ScrollConfiguration(
                    behavior: const NoGlowScrollBehavior(),
                    child: w,
                  );
                },
                onUnknownRoute: (_) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => NotFoundPage(),
                );
              },
              );
            },
          ),
        ),
        backgroundColor: Colors.black54,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom);
  }

  // return MaterialApp(
  //   home: ContainerPage(),
  // );
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}
