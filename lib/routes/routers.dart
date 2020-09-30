import 'package:cheese_flutter/widgets/webview_page.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter/widgets.dart' as widgets;
import 'package:webview_flutter/webview_flutter.dart';

import 'community/community_router.dart';
import 'i_router.dart';
import 'login/login_router.dart';
import 'mine/mine_router.dart';
import 'not_found_page.dart';

class Routers {
  static final List<IRouterProvider> _listRouter = [];
  static String home = '/home';
  static String webViewPage = '/webView';
  
  static final Router router = Router();

  static void init() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (widgets.BuildContext context, Map<String, List<String>> params) {
      widgets.debugPrint('未找到目标页');
      return NotFoundPage();
    });

    // router.define(home,
    //     handler: Handler(
    //         handlerFunc:
    //             (BuildContext context, Map<String, List<String>> params) =>
    //                 Home()));

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first;
      final String url = params['url']?.first;
      return WebViewPage(title:title ,url: url);
    }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化

    _listRouter.add(LoginRouter());
    _listRouter.add(CommunityRouter());
    _listRouter.add(MineRouter());

    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
