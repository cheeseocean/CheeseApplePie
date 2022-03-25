import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/consts.dart';
import 'package:flutter_application/common/utils.dart';
import 'package:flutter_application/http/urls.dart';
import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/user/register/register-model.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../http/http.dart';
import '../../../widgets/text-fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    _usernameCtr.addListener(() => _formParams.username = _usernameCtr.text);
    _passwordCtr.addListener(() => _formParams.password = _passwordCtr.text);
    _password2Ctr.addListener(() => _formParams.password2 = _password2Ctr.text);
    _emailCtr.addListener(() => _formParams.email = _emailCtr.text);
    _codeCtr.addListener(() => _formParams.code = _codeCtr.text);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _FormParams _formParams = _FormParams();
  final TextEditingController _usernameCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  final TextEditingController _password2Ctr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _codeCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 处理键盘遮挡
      body: Container(
        margin: EdgeInsets.only(top: 60.w),
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    validator: (v) {
                      if (v == null || v == '') return '请输入用户名';
                      if (v.length < 2 || v.length > 18) return '长度在2-18之间';
                      return null;
                    },
                    controller: _usernameCtr,
                    decoration: inputDecoration('用户名', '请输入用户名'),
                  ),
                ),
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v == '') return '请输入密码';
                      if (v.length < 6 || v.length > 18) return '长度在6-18之间';
                      return null;
                    },
                    controller: _passwordCtr,
                    decoration: inputDecoration('密码', '请输入密码'),
                  ),
                ),
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v == '') return '请再次输入密码';
                      if (v.length < 6 || v.length > 18) return '长度在6-18之间';
                      if (v != _formParams.password) return '2次密码不一致';
                      return null;
                    },
                    controller: _password2Ctr,
                    decoration: inputDecoration('确认密码', '请再次输入密码'),
                  ),
                ),
                SizedBox(
                  height: 75.w,
                  child: TextFormField(
                    validator: (v) {
                      if (v == null || v == '') return '请输入邮箱';
                      if (!RegExp(r'\w+@\w+\.\w+').hasMatch(v)) return '请输入正确的邮箱';
                      return null;
                    },
                    controller: _emailCtr,
                    decoration: inputDecoration('邮箱', '请输入邮箱'),
                  ),
                ),
                SizedBox(
                  height: 75.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (v) {
                            if (v == null || v == '') return '请输入邮箱验证码';
                            if (!RegExp(r'^\d{6}$').hasMatch(v)) return '请输入6位数字验证码';
                            return null;
                          },
                          controller: _codeCtr,
                          decoration: inputDecoration('邮箱验证码', '请输入邮箱验证码'),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.w),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                            ),
                            onPressed: () async {
                              if (_formParams.email == '') {
                                showToast('请输入邮箱');
                                return;
                              }
                              final res = await dio.get('/getEmailCode', queryParameters: {'email': _formParams.email});
                              ResponseModel responseModel = ResponseModel.fromJson(res.data);
                              if (responseModel.status != 0) {
                                showToast(responseModel.message);
                                return;
                              }
                              showToast(responseModel.message);
                            },
                            child: Text(
                              '获取验证码',
                              style: TextStyle(fontSize: 13.sp),
                            )),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 15, 20, 15))),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      Response res = await dio.post(registerUrl, data: jsonEncode(_formParams));
                      ResponseModel responseModel = ResponseModel.fromJson(res.data);
                      showToast(responseModel.message);
                      if (responseModel.status != 0) {
                        return;
                      }
                      Timer(const Duration(seconds: 1), () => Navigator.pushNamed(context, RoutePath.personal));
                    },
                    child: const Text('注册')),
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        '登录',
                        style: TextStyle(color: XColor.primary),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/login'),
                    ),
                    Text('找回密码', style: TextStyle(color: XColor.primary))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormParams {
  String email;
  String password;
  String password2;
  String username;
  String code;

  _FormParams({this.email = '', this.password = '', this.password2 = '', this.username = '', this.code = ''});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password, "username": username, "code": code};
  }
//

}
