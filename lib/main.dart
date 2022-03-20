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
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: routes,
          onGenerateRoute: (settings) {
            print(settings);
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
