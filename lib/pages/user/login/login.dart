import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/user/login/login-model.dart';
import 'package:flutter_application/states/states.dart';
import 'package:provider/provider.dart';
import '../../../common/consts.dart';
import '../../../http/http.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/text-fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _form = {'username': '', 'password': ''};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 150.w,
                ),
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    decoration: inputDecoration('用户名', '请输入用户名'),
                    validator: (v) {
                      if (v == null || v == '') return '请输入用户名';
                      if (v.length < 2 || v.length > 18) return '长度在2-18之间';
                      return null;
                    },
                    onSaved: (v) => _form['username'] = v!,
                  ),
                ),
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    obscureText: true,
                    decoration: inputDecoration('密码', '请输入密码'),
                    validator: (v) {
                      if (v == null || v == '') return '请输入密码';
                      if (v.length < 6 || v.length > 18) return '长度在6-18之间';
                      return null;
                    },
                    onSaved: (v) => _form['password'] = v!,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 15, 20, 15))),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState?.save();
                    try {
                      var res = await dio.post(loginUrl, data: _form);
                      ResponseModel responseModel = ResponseModel.fromJson(res.data);
                      showToast(responseModel.message);
                      if (responseModel.status != 0) {
                        return;
                      }
                      UserState userState = Provider.of(context, listen: false);
                      userState.login = true;
                      Timer(const Duration(seconds: 1), () => Navigator.pushNamed(context, '/'));
                    } on DioError catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('登录'),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        '注册',
                        style: TextStyle(color: XColor.primary),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/register'),
                    ),
                    Text('找回密码', style: TextStyle(color: XColor.primary))
                  ],
                )
              ],
            ),
          ),
        ),
        padding: EdgeInsets.all(20.w),
      ),
    );
  }
}
