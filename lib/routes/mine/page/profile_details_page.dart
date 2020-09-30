import 'package:cheese_flutter/models/user.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetailsPage extends StatefulWidget {
  @override
  State createState() {
    return _ProfileDetailsPageState();
  }
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("我的资料"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            Container(
              child: Column(
                children: [
                  Item(
                    prefix: "昵称",
                    content: user.nickname,
                    onTap: () {},
                  ),
                  Item(
                    prefix: "昵称",
                    content: user.nickname,
                    onTap: () {},
                  ),
                  Item(
                    prefix: "昵称",
                    content: user.nickname,
                    onTap: () {},
                  ),
                  Item(
                    prefix: "昵称",
                    content: user.nickname,
                    onTap: () {},
                  ),
                  Item(
                    prefix: "昵称",
                    content: user.nickname,
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String prefix;
  final String content;
  final VoidCallback onTap;

  Item({@required this.prefix, this.content, @required this.onTap});

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
            Expanded(flex: 2, child: Text(prefix)),
            Expanded(
                flex: 6,
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w100),
                )),
            Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right_rounded))
          ],
        ),
      ),
    );
  }
}
