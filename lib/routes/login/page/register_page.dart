import 'dart:io';
import 'dart:ui';
import 'dart:convert' show utf8;

import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/index.dart';
import 'package:cheese_flutter/widgets/custom_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterPage> {
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  var emailRegExp = RegExp(p);

  GlobalKey _emailKey = GlobalKey<FormFieldState>();

  String validateEmail(text) {
    if (text == null || (text as String).isEmpty) {
      return "邮箱不能为空";
    } else if (emailRegExp.hasMatch(text)) {
      return null;
    }
    return "邮箱格式错误";
  }

  bool _startRegister = false;

  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();

  GlobalKey _formKey = GlobalKey<FormState>();
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  String _avatarPath;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  final String _defaultAvatarPath = "assets/svgs/ic_camera.svg";

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    setState(() {
      _avatarPath = pickedFile.path;
    });
  }

  void getVerifyCode() async {
    String email = _emailController.text;
    if (!(_emailKey.currentState as FormFieldState).validate()) {
      return;
    }
    Cheese.getVerifyCode(email).then((value) => print(value));
  }

  void showSnackBar(Widget content) {
    (_scaffoldKey.currentState as ScaffoldState).showSnackBar(CustomSnackBar(
      content: content,
      duration: Duration(seconds: 2),
    ));
  }

  void register() async {
    if (_avatarPath == null || !(_avatarPath.trim().length > 0)) {
      showSnackBar(Text("请选择头像"));
      return null;
    }
    if (!(_formKey.currentState as FormState).validate()) {
      return null;
    }
    final registerInfo = {
      "avatar":
          await MultipartFile.fromFile(_avatarPath, filename: "new_avatar.jpg"),
      "username": _usernameController.text,
      "password": _passwordController.text,
      "nickname": _nicknameController.text,
      "email": _emailController.text,
      "code": _codeController.text
    };
    print(registerInfo);
    setState(() {
      _startRegister = true;
    });
    Cheese.register(registerInfo).then((value) {
      showSnackBar(Text("注册成功"));
      setState(() {
        _startRegister = false;
      });
    }).catchError((e) {
      setState(() {
        _startRegister = false;
      });
      showSnackBar(Text("服务器错误"));
    });
    // cheese.getGithubUser();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget get avatarSelector => Container(
        width: 110,
        height: 110,
        // color: Colors.blue,
        child: InkWell(
          onTap: getImage,
          child: _avatarPath == null
              ? CircleAvatar(
                  // backgroundColor: Colors.grey[300],
                  child: SvgPicture.asset(_defaultAvatarPath,
                      width: 50, height: 50))
              : CircleAvatar(
                  // backgroundColor: Colors.blue,
                  backgroundImage: FileImage(File(_avatarPath)),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final fieldPadding = EdgeInsets.only(bottom: 12, left: 10, right: 10);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Register",
          ),
          toolbarHeight: 48,
        ),
        body: Container(
          height: window.physicalSize.height,
          // decoration: BoxDecoration(color: Colors.grey[200]),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              avatarSelector,
              SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: fieldPadding,
                      child: TextFormField(
                          autofocus: false,
                          focusNode: _usernameFocusNode,
                          controller: _usernameController,
                          validator: (value) {
                            return value.trim().length > 0 ? null : "用户名不能为空";
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "用户名",
                            hintText: "用户名唯一且不能修改",
                          )),
                    ),
                    Padding(
                      padding: fieldPadding,
                      child: TextFormField(
                          focusNode: _passwordFocusNode,
                          autofocus: false,
                          controller: _passwordController,
                          validator: (value) {
                            return value.trim().length > 0
                                ? null
                                : "密码必须大于等于6位";
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "密码",
                            hintText: "密码需大于6位",
                          )),
                    ),
                    Padding(
                      padding: fieldPadding,
                      child: TextFormField(
                          focusNode: _nicknameFocusNode,
                          controller: _nicknameController,
                          validator: (value) {
                            return value.trim().length > 0 ? null : "昵称不能为空";
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "昵称",
                            hintText: "取个好听的名字吧",
                          )),
                    ),
                    Padding(
                      padding: fieldPadding,
                      child: TextFormField(
                          key: _emailKey,
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "邮箱",
                            hintText: "邮箱用于找回密码",
                          )),
                    ),
                    Padding(
                        padding: fieldPadding,
                        child: TextFormField(
                          controller: _codeController,
                          focusNode: _codeFocusNode,
                          validator: (value) {
                            return value.trim().length > 0 ? null : "验证码不能为空";
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "验证码",
                            hintText: "邮箱6位验证码",
                            suffixIcon: FlatButton(
                              textColor: Colors.blue[300],
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              disabledTextColor: Colors.grey,
                              child: Text(
                                "获取验证码",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              onPressed: getVerifyCode,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                  width: 200,
                  height: 45,
                  child: RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: _startRegister
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.yellow,
                              strokeWidth: 2.0,
                            ))
                        : Text("注册"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: register,
                  )),
            ],
          )),
        ));
  }
}

//class WithIndicatorButton extends StatefulWidget{
//
//  @override
//  State<StatefulWidget> createState() {
//    return _WithIndicatorButton();
//  }
//}
//
//class _WithIndicatorButton extends State<WithIndicatorButton>{
//  @override
//  Widget build(BuildContext context) {
//    Builder
//  }
//}

