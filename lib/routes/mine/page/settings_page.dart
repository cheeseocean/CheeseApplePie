import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:cheese_flutter/routes/login/login_router.dart';
import 'package:cheese_flutter/routes/mine/mine_router.dart';
import 'package:cheese_flutter/widgets/confirm_dialog.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode =
        Provider.of<ThemeModel>(context, listen: false).getThemeMode();
    String darkMode;
    switch (themeMode.value) {
      case 'Dark':
        darkMode = '开启';
        break;
      case 'Light':
        darkMode = '关闭';
        break;
      default:
        darkMode = '跟随系统';
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("设置"),
        ),
        body: Column(
          children: [
            Item(
              prefix: "账户管理",
              onTap: () {},
            ),
            Item(
              prefix: "深色模式",
              hint: darkMode,
              onTap: () {
                NavigatorUtils.push(context, MineRouter.themePage);
              },
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    showDialog<bool>(
                            context: context,
                            builder: (_) => ConfirmDialog(hint: "退出帐号将清除本地缓存"))
                        .then((result) {
                      if (result) {
                        context.read<UserModel>().clearUserCache();
                        NavigatorUtils.push(context, LoginRouter.loginPage,
                            transition: TransitionType.fadeIn,
                            clearStack: true);
                      }
                    });
                  },
                  child: Text(
                    "退出当前帐号",
                    style: TextStyle(color: Colors.red),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ),
            ),
          ],
        ));
  }
}

class Item extends StatelessWidget {
  final String prefix;
  final String hint;
  final VoidCallback onTap;

  Item({@required this.prefix, this.hint, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        height: 48.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(
              context,
              width: 0.6,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(flex: 8, child: Text(prefix)),
            Expanded(
                flex: 2,
                child: hint != null
                    ? Text(
                        hint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w100),
                      )
                    : const SizedBox()),
            Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right_rounded))
          ],
        ),
      ),
    );
  }
}
