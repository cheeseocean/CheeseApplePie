import 'package:cheese_flutter/models/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String settingsAssetName = "assets/svgs/ic_settings.svg";

class UserDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserDetailsPageState();
  }
}

class _UserDetailsPageState extends State<UserDetailsPage> {

  User _user = User();

  final List<String> _tabs = ['帖子', '动态'];
  static final double avatarSize = 88.0;
  static final double toolbarHeight = 56.0;
  static final double headerHeight = 300.0;

  @override
  Widget build(BuildContext context) {}

  Widget get header => Container(
    foregroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.0, 0.5),
        end: Alignment(0.0, 0.0),
        colors: <Color>[
          Color(0x60000000),
          Color(0x00000000),
        ],
      ),
    ),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/mine_header_bg.jpg",
            ),
            fit: BoxFit.fill)),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: avatarSize,
            width: avatarSize,
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                // backgroundColor: Colors.amber,
                backgroundImage: _user.avatarUrl != null
                    ? NetworkImage(_user.avatarUrl)
                    : AssetImage("assets/images/avatar_placeholder.jpg"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              _user == null ? "用户未加载" : _user.nickname ?? "昵称未加载",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              _user == null ? "用户未加载" : _user.bio ?? "个签未加载",
              style: TextStyle(
                // color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );
}
