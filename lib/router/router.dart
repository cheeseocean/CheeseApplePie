import 'package:flutter/material.dart';
import 'package:flutter_application/layout.dart';
import 'package:flutter_application/pages/community/community.dart';
import 'package:flutter_application/pages/creation/creation.dart';
import 'package:flutter_application/pages/index/index.dart';
import 'package:flutter_application/pages/personal/personal.dart';
import 'package:flutter_application/pages/videos/videos.dart';
import '../pages/user/login/login.dart';
import '../pages/user/register/register.dart';

const homePath = '/home';
const loginPath = '/login';
const registerPath = '/register';

abstract class RoutePage<T> extends State<StatefulWidget> {

  void push(String path);
}

GlobalKey layoutKey = GlobalKey();
Map<String, GlobalKey<RoutePage>> routeKeys = {homePath.substring(1): layoutKey};

void routePush(String path) {
  List<String> paths = path.substring(1).split('/');
  routeKeys[paths[0]].currentState
}

Map<String, Widget Function(BuildContext)> routes = {
  homePath: (context) => LayoutPage(),
  loginPath: (context) => const LoginPage(),
  registerPath: (context) => const RegisterPage(),
};

Map otherRoutes = {
  homePath.substring(1): {
    'widget': (Widget child, int index) => LayoutPage(child, index),
    'children': {
      'index': {'widget': () => const IndexPage()},
      'community': {'widget': () => const CommunityPage()},
      'videos': {'widget': () => const VideosPage()},
      'creation': {'widget': () => const CreationPage()},
      'personal': {'widget': () => const PersonalPage()}
    }
  }
};

CustomRoute index = CustomRoute('index', (child) => IndexPage());
CustomRoute community = CustomRoute('community', (child) => IndexPage());
CustomRoute videos = CustomRoute('videos', (child) => IndexPage());
CustomRoute creation = CustomRoute('creation', (child) => IndexPage());
CustomRoute personal = CustomRoute('personal', (child) => IndexPage());
CustomRoute layout = CustomRoute(homePath.substring(1), (child) => LayoutPage(child),
    Map.from({'index': index, 'community': community, 'videos': videos, 'creation': creation, 'personal': personal}));

class CustomRoute {
  String path;
  Function(Widget? child) widget;
  Map<String, CustomRoute>? children;

  CustomRoute(this.path, this.widget, [this.children]);
}
