import 'package:flutter/material.dart';
import 'package:flutter_application/states/states.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'common/consts.dart';
import 'http/cookie.dart';
import 'http/http.dart' as http;
import 'router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  http.main();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

typedef WidgetFn = Widget Function(BuildContext);

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkCookie();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => ChangeNotifierProvider.value(
        value: UserState(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          // showSemanticsDebugger: true,
          initialRoute: homePath,
          debugShowCheckedModeBanner: false,
          routes: routes,
          onGenerateRoute: (settings) {
            print(settings.name);
            String name = '';
            if (settings.name == '/') {
              return MaterialPageRoute(builder: routes[homePath] as WidgetFn);
            }
            List<String>? paths = settings.name?.substring(1).split('/');
            if (paths == null) return MaterialPageRoute(builder: routes[loginPath] as WidgetFn);
            // var rootWidget = otherRoutes[paths[0]];
            var widgets = [];
            var curRoute = otherRoutes;
            for (var path in paths) {
              widgets.add(curRoute[path]['widget']);
              curRoute = curRoute[path]['children'] ?? Map();
            }
            var curWidget = widgets.last;
            print('111$curWidget');
            for (int i = widgets.length - 2; i >= 0; i--) {
              print(widgets[i]);
              curWidget = widgets[i](curWidget(), settings.arguments);
            }
            print(curWidget);
            print('paths $paths');
            print(settings.arguments);
            return MaterialPageRoute(builder: (context) => curWidget);
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(button: TextStyle(fontSize: 15.sp)),
          ),
          // builder: EasyLoading.init(),
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          // home: const LayoutPage(),
        ),
      ),
    );
  }
}
