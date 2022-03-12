import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../http/http.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _Form _form = _Form('', '', '', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100.r),
        padding: EdgeInsets.all(20.r),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (v) {
                    if (v == null || v == '') return '请输入用户名';
                    if (v.length < 2 || v.length > 10) return '长度在2-10之间';
                    return null;
                  },
                  onSaved: (v) => _form.username = v!,
                  decoration:
                      const InputDecoration(hintText: '请输入用户名', contentPadding: EdgeInsets.all(5), labelText: '用户名', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20.r),
                TextFormField(
                  validator: (v) {
                    if (v == null || v == '') return '请输入密码';
                    if (v.length < 6 || v.length > 18) return '长度在6-18之间';
                    return null;
                  },
                  onSaved: (v) => _form.password = v!,
                  decoration:
                      const InputDecoration(hintText: '请输入密码', contentPadding: EdgeInsets.all(5), labelText: '密码', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20.r),
                TextFormField(
                  validator: (v) {
                    if (v == null || v == '') return '请再次输入密码';
                    if (v.length < 6 || v.length > 18) return '长度在6-18之间';
                    return null;
                  },
                  onSaved: (v) => _form.password2 = v!,
                  decoration:
                      const InputDecoration(hintText: '请再次输入密码', contentPadding: EdgeInsets.all(5), labelText: '确认密码', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20.r),
                TextFormField(
                  validator: (v) {
                    if (v == null || v == '') return '请输入邮箱';
                    if (!RegExp(r'\w+@\w+\.\w+').hasMatch(v)) return '请输入正确的邮箱';
                    return null;
                  },
                  onSaved: (v) => _form.email = v!,
                  decoration:
                      const InputDecoration(hintText: '请输入邮箱', contentPadding: EdgeInsets.all(5), labelText: '邮箱', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20.r),
                ElevatedButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 15, 20, 15))),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();
                      dio.post('/register', data: _form.toParams());
                    },
                    child: const Text('注册'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form {
  String username = '';
  String password = '';
  String password2 = '';
  String email = '';

  _Form(this.username, this.password, this.password2, this.email);

  String toParams() {
    return jsonEncode({'username': username, 'password': password, 'email': email});
  }
}
