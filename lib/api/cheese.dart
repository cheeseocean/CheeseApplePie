import 'dart:convert';
import 'dart:io';
import 'package:cheese_flutter/common/intercepters.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/common/page_parameter.dart';
import 'package:cheese_flutter/models/commentList.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

import '../models/index.dart';
import '../common/global.dart';

class Cheese {
  Cheese([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;

  Options _options;

  static PersistCookieJar cookieJar;

  static CookieManager cookieManager;

  static Dio dio = new Dio(BaseOptions(
    baseUrl: Global.API_BASE_URL,
    headers: {
      HttpHeaders.acceptHeader: "application/json",
    },
    // contentType: ContentType(primaryType, subType)
  ));

  static void init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print(appDocPath);
    cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    cookieManager = CookieManager(cookieJar);
    print(appDocPath);
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(cookieManager);

    // 添加缓存插件
    // dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    // if (!Global.isRelease) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (uri) {
    //       return "PROXY 10.1.10.250:8888";
    //     };
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  // Future getGithubUser() async {
  //   Response response = await dio.get("/users/xxxcrel");
  //   print(response.data);
  // }

  static Future<Result> getVerifyCode(String email) async {
    Response response =
        await dio.get("/code/email", queryParameters: {"address": email});

    var cookies = cookieJar.loadForRequest(response.request.uri);
    print(CookieManager.getCookies(cookies));

    return Result.fromJson(response.data);
  }

  static Future<Result> register(Map<String, dynamic> registerInfo) async {
    FormData reigsterForm = FormData.fromMap(registerInfo);
    Response response = await dio.post("/register", data: reigsterForm);
    return Result.fromJson(response.data);
  }

  static Future<Result> login(String username, String password) async {
    String jwtToken;
    var loginForm = {"username": username, "password": password};
    Response response = await dio.post("/login",
        data: loginForm,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    jwtToken = response.headers[HttpHeaders.authorizationHeader][0];

    dio.options.headers[HttpHeaders.authorizationHeader] = jwtToken;
    Global.profile.token = jwtToken;

    return Result.fromJson(response.data);
  }

  static Future<User> getUserInfo() async {
    Response response = await dio.get("/user");
    return User.fromJson(response.data);
  }

  static Future<Result> publishBubble(MultipartFile metaData,
      {Map<String, String> fileMappings}) async {
    List<MultipartFile> images = <MultipartFile>[];
    //TODO: file sync can't get image
    fileMappings.forEach((key, value) {
      images.add(MultipartFile.fromFileSync(key, filename: value));
    });
    FormData postForm = FormData.fromMap({
      "meta-data": metaData,
      "images": images
      // MultipartFile.fromFileSync("/data/user/0/com.example.cheese_flutter/cache/1758880_Screenshot_20200705_022530_com.netease.cloudmusic.jpg", filename: "bubble.jpg")
    });
    Response response = await dio.post("/user/posts",
        data: postForm,
        options:
            Options(headers: {Headers.contentTypeHeader: "multipart/mixed"}));
    // print(response.data);
    return Result.fromJson(response.data);
  }

  static Future<Result> addReview(int postId, String content,
      {int parentId}) async {
    var reviewJson = {"content": content, "parent_id": parentId};
    // print("hell${reviewJson.toString()}");
    FormData reviewForm = FormData.fromMap({
      "meta-data": MultipartFile.fromString(JsonEncoder().convert(reviewJson), contentType: MediaType.parse("application/json"))
    });
    Response response =
        await dio.post("/posts/$postId/comments/", data: reviewForm);
    return Result.fromJson(response.data);
  }

  static Future<CategoryList> getCategoryList({PageParameter page}) async {
    Response response = await dio.get("/categories");
    return CategoryList.fromJson(response.data);
  }

  static Future<BubbleList> getBubbleList(String requestResUrl,
      {PageParameter pageParameter}) async {
    print(pageParameter.toMap());
    Response response = await dio.get(requestResUrl, queryParameters: pageParameter.toMap());
    return BubbleList.fromJson(response.data);
  }

  static Future<CommentList> getCommentListOfBubble(num postId,
      {String level, num commentedId, PageParameter pageParameter}) async {
    String _level = level ?? "first";
    Map<String, String> queryParams = {"level": _level};
    if (_level == "second") {
      assert(commentedId != null);
      queryParams["commented_id"] = "$commentedId";
    } else
      queryParams["commented_id"] = "0";
    print(queryParams);
    Response response =
        await dio.get("/posts/$postId/comments", queryParameters: queryParams );
    return CommentList.fromJson(response.data);
  }


}
