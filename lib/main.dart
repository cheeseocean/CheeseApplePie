import 'package:cheese_flutter/common/notifiers.dart';
import 'package:cheese_flutter/pages/container_route.dart';
import 'package:cheese_flutter/splash_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'common/global.dart';
import 'routes/login_route.dart';
import 'routes/register_route.dart';
import 'package:flutter/scheduler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //初始化用户数据,如果无则登入
  Global.init().then((e) => runApp(MyApp())).catchError((e) => print(e));

  // runApp(MyApp());
  print("runMyApp");
  if (Platform.isAndroid) {
    timeDilation = 2.0;
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  AssetPicker.registerObserve();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MyApp build");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserModel()),
          ChangeNotifierProvider.value(value: ThemeModel())
        ],
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          return OKToast(
            child: MaterialApp(
              theme: ThemeData.from(
                colorScheme: const ColorScheme.light(),
              ).copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  },
                ),
              ),
              home: const SplashPage(),
              routes: {
                "login": (context) => LoginRoute(),
                "register": (context) => RegisterRoute(),
                "container": (context) => ContainerPage()
              },
              builder: (BuildContext c, Widget w) {
                return ScrollConfiguration(
                  behavior: const NoGlowScrollBehavior(),
                  child: w,
                );
              },
            ),
          );
        }));
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
