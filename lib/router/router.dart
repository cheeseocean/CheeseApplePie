import 'package:flutter/material.dart';
import 'package:flutter_application/layout.dart';
import 'package:flutter_application/pages/community/community.dart';
import 'package:flutter_application/pages/creation/creation.dart';
import 'package:flutter_application/pages/creation/preview-post.dart';
import 'package:flutter_application/pages/index/index.dart';
import 'package:flutter_application/pages/personal/personal.dart';
import 'package:flutter_application/pages/videos/videos.dart';
import '../pages/user/login/login.dart';
import '../pages/user/register/register.dart';

Map<String, Widget Function(BuildContext)> routes = {
  RoutePath.home: (context) => LayoutPage(key: NestedRouter.routeKeys[RoutePath.home]),
  RoutePath.login: (context) => const LoginPage(),
  RoutePath.register: (context) => const RegisterPage(),
  RoutePath.previewPost: (context) => PreviewPostPage(),
};

class RoutePath {
  // normal route
  static const login = '/login';
  static const register = '/register';
  static const previewPost = '/preview-post';

  // nested route
  static const home = '/home';
  static const index = home + '/index';
  static const community = home + '/community';
  static const videos = home + '/videos';
  static const creation = home + '/creation';
  static const personal = home + '/personal';
}

abstract class RoutePage<T extends StatefulWidget> extends State<T> {
  void setRoute(Widget page, String path, [Object? arguments]);
}

class NestedRouter {
  static Map<String, Widget> nestedRouteMap = {
    RoutePath.index: const IndexPage(),
    RoutePath.community: const CommunityPage(),
    RoutePath.videos: const VideosPage(),
    RoutePath.creation: const CreationPage(),
    RoutePath.personal: const PersonalPage()
  };

  static void push(String path, [Object? arguments]) {
    List<String> paths = path.substring(1).split('/');
    assert(paths.length > 1);
    List pages = [];
    String pre = '/' + paths[0];
    List<GlobalKey<RoutePage>> keys = [routeKeys[pre]!];
    for (int i = 1; i < paths.length; i++) {
      String path = paths[i];
      pages.add(nestedRouteMap[pre += '/' + path]);
      if (routeKeys[pre] != null) keys.add(routeKeys[pre]!);
    }
    for (int i = 0; i < keys.length; i++) {
      keys[i].currentState?.setRoute(pages[i], path, i == keys.length - 1 ? arguments : null);
    }
  }

  static Map<String, GlobalKey<RoutePage>> routeKeys = {RoutePath.home: GlobalKey<LayoutPageState>()};
}
