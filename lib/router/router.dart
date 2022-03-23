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
// nested route path
const indexPath = 'index';
const communityPath = 'community';
const videosPath = 'videos';
const creationPath = 'creation';
const personalPath = 'personal';

abstract class RoutePage<T extends StatefulWidget> extends State<T> {
  void push(String path);
}

Map<String, GlobalKey<RoutePage>> routeKeys = {homePath: GlobalKey<LayoutPageState>()};

void nestedRoutePush(String path) {
  List<String> paths = path.substring(1).split('/');
  assert(paths.length == 2);
  routeKeys['/' + paths[0]]?.currentState?.push(path);
}

Map<String, Widget Function(BuildContext)> routes = {
  homePath: (context) => LayoutPage(key: routeKeys[homePath]),
  loginPath: (context) => const LoginPage(),
  registerPath: (context) => const RegisterPage(),
};

Map otherRoutes = {
  homePath.substring(1): {
    'widget': (Widget child, int index) => LayoutPage(),
    'children': {
      'index': {'widget': () => const IndexPage()},
      'community': {'widget': () => const CommunityPage()},
      'videos': {'widget': () => const VideosPage()},
      'creation': {'widget': () => const CreationPage()},
      'personal': {'widget': () => const PersonalPage()}
    }
  }
};

class CustomRoute {
  Function(Widget? child) widget;
  Map<String, CustomRoute>? children;

  CustomRoute(this.widget, [this.children]);
}

Map<String, CustomRoute> nestedRoutes = {
  homePath: CustomRoute(
      (child) => LayoutPage(),
      Map.from({
        indexPath: CustomRoute((child) => IndexPage()),
        communityPath: CustomRoute((child) => IndexPage()),
        videosPath: CustomRoute((child) => IndexPage()),
        creationPath: CustomRoute((child) => IndexPage()),
        personalPath: CustomRoute((child) => IndexPage())
      }))
};
