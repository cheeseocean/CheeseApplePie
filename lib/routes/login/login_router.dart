import 'package:cheese_flutter/routes/i_router.dart';
import 'package:cheese_flutter/routes/login/page/container_page.dart';
import 'package:fluro/fluro.dart';
import 'package:fluro/src/router.dart';

import 'page/login_page.dart';
import 'page/register_page.dart';

class LoginRouter implements IRouterProvider{
  
  static String loginPage = "/login";
  static String registerPage = "/login/register";
  static String containerPage = "/login/container";
  
  @override
  void initRouter(Router router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => LoginPage()));
    router.define(registerPage, handler: Handler(handlerFunc: (_, __) => RegisterPage()));
    router.define(containerPage, handler: Handler(handlerFunc: (_, __) => ContainerPage()));
  }

  
}