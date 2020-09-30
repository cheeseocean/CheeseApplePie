import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/user.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:cheese_flutter/routes/mine/page/edit_profile_page.dart';
import 'package:cheese_flutter/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class ProfileDetailsPage extends StatefulWidget {
  @override
  State createState() {
    return _ProfileDetailsPageState();
  }
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  User _user;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    } else {
      showDialog(
          context: context,
          builder: (_) => LoadingDialog(
                type: LoadingType.cubeGrid,
              ));
      Cheese.updateAvatar(pickedFile.path).then((result) {
        Navigator.of(context).pop();
        updateUser();
      }).catchError((err) {
        Navigator.of(context).pop();
        showToast("上传失败");
      });
    }
  }

  void updateUser() {
    Cheese.getUserInfo().then((user) {
      // print("update avatar:${user.toJson()}");
      context.read<UserModel>().user = user;
      showToast("更新成功");
    });
  }

  void updateGender(int gender) {
    Cheese.updateInfo("gender", gender.toString()).then((value) {
      Navigator.of(context).pop();
      updateUser();
    }).catchError((err) {
      Navigator.of(context).pop();
      showToast("更新失败");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserModel>(context).user;
    print(_user.avatarUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text("我的资料"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Stack(fit: StackFit.expand, children: [
                InkWell(
                  onTap: getImage,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_user.avatarUrl),
                  ),
                ),
                Positioned(
                  right: 12.0,
                  bottom: 4.0,
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.indigoAccent,
                    size: 18.0,
                  ),
                )
              ]),
            ),
            Container(
              child: Column(
                children: [
                  Item(
                    prefix: "昵称",
                    content: _user.nickname ?? "未设置",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return EditProfilePage(
                            title: "昵称",
                            updatedField: "nickname",
                            initialValue: _user.nickname ?? null,
                            maxLines: 1,
                            limitWord: 20,
                            hint: "好听的名字让大家更快记住你",
                          );
                        }),
                      ).then((result) {
                        if (result != null && result) updateUser();
                      });
                    },
                  ),
                  Item(
                    prefix: "个性签名",
                    content: _user.bio ?? "未设置",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return EditProfilePage(
                            title: "个性签名",
                            updatedField: "bio",
                            initialValue: _user.bio ?? null,
                            maxLines: 3,
                            limitWord: 50,
                            hint: "彰显你的个性",
                          );
                        }),
                      ).then((result) {
                        if (result != null && result) updateUser();
                      });
                    },
                  ),
                  Item(
                    prefix: "地区",
                    content: _user.location ?? "未设置",
                    onTap: () {},
                  ),
                  Item(
                    prefix: "性别",
                    content: convertGender(_user.gender) ?? "未设置",
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          context: context,
                          builder: (_) => Container(
                                height: 150.0,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
                                              updateGender(1);
                                            },
                                            child: Center(child: Text("男")))),
                                    Expanded(
                                      flex: 1,
                                      child: FlatButton(
                                          onPressed: () {
                                            updateGender(0);
                                          },
                                          child: Center(child: Text("女"))),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            highlightColor: Colors.grey[200],
                                            child: Text("取消")))
                                  ],
                                ),
                              ));
                    },
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

String convertGender(num gender) {
  var genderList = ["女", "男"];
  return gender == null ? null : genderList[gender];
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
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(prefix)),
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    );
  }
}
