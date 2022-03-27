import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/cookie.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/router/router.dart';

// const String host = '192.168.1.53';
const String host = '192.168.84.19';
const String port = '5000';

Dio dio = Dio(BaseOptions(receiveTimeout: 10000, baseUrl: 'http://localhost:5000/api'));
Loading loading = Loading();
int count = 0;

void main() async {
  bool isWeb = identical(0, 0.0);
  String baseUrl = isWeb ? '/api' : 'http://$host:$port';
  dio.options.baseUrl = baseUrl;
  dio.interceptors.add(CookieManager(await getCookieJar()));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    count++;
    if (loading.autoOpen && loading.closed) loading.open();
    return handler.next(options);
  }, onResponse: (response, handler) {
    if (--count == 0) {
      loading.autoOpen = true;
      if (!loading.manual && !loading.closed) loading.close();
    }
    if (ResponseModel.fromJson(response.data).status == 401) {
      navigatorKey.currentState?.pushNamed('/login');
    }
    return handler.next(response);
  }, onError: (DioError e, handler) {
    showToast('网络异常');
    if (--count == 0) {
      // 网络原因应该关闭loading
      loading.autoOpen = true;
      if (!loading.closed) loading.close();
    }
    return handler.next(e);
  }));
}
