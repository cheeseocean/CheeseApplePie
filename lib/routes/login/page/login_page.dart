import 'dart:ui';

import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:cheese_flutter/widgets/custom_snack_bar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../login_router.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  /// /// 字段的输入控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Focus nodes for input field. Basically for dismiss.
  /// 输入框的焦点实例。主要用于点击其他位置时失焦动作。
  final FocusNode usernameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  /// Form state.
  /// 表单状态
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  /// TEC for fields.

  String _username = ''; // 账户变量
  String _password = ''; // 密码变量

  bool _agreement = false; // 是否已勾选统一协议
  bool _logining = false; // 是否正在登陆
  bool _loginDisabled = true; // 是否允许登陆
  bool _isObscure = true; // 是否开启密码显示
  bool _usernameCanClear = false; // 账户是否可以清空
  bool _keyboardAppeared = false; // 键盘是否出现

  /// Listener for username text field.
  /// 账户输入字段的监听
  void usernameListener() {
    _username = _usernameController.text;
    if (mounted) {
      if (_usernameController.text.isNotEmpty && !_usernameCanClear) {
        setState(() {
          _usernameCanClear = true;
        });
      } else if (_usernameController.text.isEmpty && _usernameCanClear) {
        setState(() {
          _usernameCanClear = false;
        });
      }
    }
  }

  /// Listener for password text field.
  /// 密码输入字段的监听
  void passwordListener() {
    _password = _passwordController.text;
  }

  @override
  void initState() {
    super.initState();

    /// Bind text fields listener.
    /// 绑定输入部件的监听
    _usernameController..addListener(usernameListener);
    _passwordController..addListener(passwordListener);
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    usernameNode
      ..unfocus()
      ..dispose();
    passwordNode
      ..unfocus()
      ..dispose();
    _loginKey.currentState?.reset();
    _loginKey.currentState?.dispose();
    super.dispose();
  }

  void doLogin() {
    try {
      if (_loginKey.currentState.validate()) {
        _loginKey.currentState.save(); //??
        Cheese.login(_usernameController.text, _passwordController.text)
            .then((result) {
          print(result.data);
          showToast(result.data ?? "no message");
          setState(() {
            _logining = true;
          });
          NavigatorUtils.push(context, LoginRouter.containerPage, transition: TransitionType.fadeIn, clearStack: true);
        }).catchError((error) {
          print(error);
          (_scaffoldKey.currentState as ScaffoldState)
              .showSnackBar(CustomSnackBar(
            content: Text("登入失败"),
            duration: Duration(seconds: 2),
          ));
        });
      } else {
        print("validate fail");
        showToast("验证失败");
      }
    } catch (e) {
      print(e);
    }
  }

  /// Function called when triggered listener.
  /// 触发页面监听器时，所有的输入框失焦，隐藏键盘。
  void dismissFocusNodes() {
    if (usernameNode?.hasFocus ?? false) {
      usernameNode?.unfocus();
    }
    if (passwordNode?.hasFocus ?? false) {
      passwordNode.unfocus();
    }
  }

  Widget get topLogo => Hero(
        tag: "LOGO",
        child: Text(
          "NIOT",
          style: TextStyle(
              fontFamily: "Chocolate",
              fontSize: 100.0,
              color: Colors.amber,
              decoration: TextDecoration.none),
        ),
      );

  /// Wrapper for content part.
  /// 内容块包装
  Widget contentWrapper({@required List<Widget> children}) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismissFocusNodes();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget get registerButton => SizedBox(
        height: 46,
        child: RaisedButton(
            color: Colors.amber[200],
            highlightColor: Colors.amberAccent[400],
            child: Text("注册"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: () {
              NavigatorUtils.push(context, LoginRouter.registerPage);
            }),
      );
  Widget get loginButton => SizedBox(
      height: 46,
      child: RaisedButton(
        color: Colors.blue,
        highlightColor: Colors.blue[700],
        child: Text("登入"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        onPressed: doLogin,
      ));
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(brightness: themeData.brightness),
      body: Container(
          // decoration: BoxDecoration(
          //   // color: Colors.white,
          //   gradient: LinearGradient(
          //       colors: [Colors.lime[200], Colors.cyan[200]]), //背景渐变
          // ),
          // padding: EdgeInsets.only(left: 60, right: 60),
          child: Stack(children: [
            contentWrapper(
              children: [
                Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      topLogo,
                      TextFormField(
                        autofocus: false,
                        focusNode: usernameNode,
                        controller: _usernameController,
                        // enabled: !_logining,
                        validator: (text) {
                          return text.trim().length > 0 ? null : "用户名不能为空";
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "用户名",
                          filled: true,
                          
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        focusNode: passwordNode,
                        controller: _passwordController,
                        validator: (text) {
                          return text.trim().length > 0 ? null : "用户名不能为空";
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "密码",
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.visibility_off),
                            iconSize: 18,
                          ),
                          
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                    heightFactor: 1.0,
                    alignment: FractionalOffset(0.95, 0.5),
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        print("pressed");
                      },
                      child: Text(
                        "忘记密码",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: registerButton,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: loginButton,
                    ),
                  ],
                ),
              ],
            ),
          ])),
    );
  }
}
