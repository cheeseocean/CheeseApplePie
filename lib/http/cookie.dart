import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../states/states.dart';

PersistCookieJar? persistCookieJar;

// 校验cookie
void checkCookie() async {
  PersistCookieJar persistCookieJar = await getCookieJar();
  List<Cookie> cookies = await persistCookieJar.loadForRequest(Uri(host: host));
  UserState userState = Provider.of(navigatorKey.currentContext as BuildContext, listen: false);
  userState.login = cookies.isNotEmpty;
}

// 获取cookie储存对象
Future<PersistCookieJar> getCookieJar() async {
  if (persistCookieJar != null) return Future.value(persistCookieJar);
  Directory tempDir = await getTemporaryDirectory();
  String appDocPath = tempDir.path + '/cookies';
  PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage(appDocPath));
  return cookieJar;
}
