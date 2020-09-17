import 'package:cheese_flutter/routes/community/page/category_page.dart';
import 'package:cheese_flutter/routes/i_router.dart';
import 'package:fluro/fluro.dart';

class CommunityRouter extends IRouterProvider{

  static String communityPage = "/community";
  static String categoryPage = "/community/categories/:categoryName";

  void initRouter(Router router){
    router.define(categoryPage, handler: Handler(handlerFunc: (_, params) => CategoryPage(categoryName: params["categoryName"][0])));
  }
}