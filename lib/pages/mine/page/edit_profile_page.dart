import 'package:cheese_flutter/api/cheese.dart';
import 'package:cheese_flutter/models/result.dart';
import 'package:cheese_flutter/routes/fluro_navigator.dart';
import 'package:cheese_flutter/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnFinishCallback = void Function(String updateValue);

class EditProfilePage extends StatelessWidget {
  final String updatedField;
  final String title;
  final String initialValue;
  final String hint;
  final int limitWord;
  final int maxLines;
  final OnFinishCallback onFinishCallback;
  final TextEditingController _controller = TextEditingController();

  EditProfilePage(
      {@required this.updatedField,
      this.title,
      this.initialValue,
      this.hint,
      this.limitWord,
      this.maxLines,
      this.onFinishCallback});

  Future<Result> updateInfo(String updatedField, String updatedValue) {
    return Cheese.updateInfo(updatedField, updatedValue);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => LoadingDialog(
                          type: LoadingType.threeBounce,
                        ));
                if (_controller.text.trim().length > 0) {
                  updateInfo(updatedField, _controller.text).then((result) {
                    //推出加载动画
                    Navigator.of(context).pop();
                    //退出当前画面
                    NavigatorUtils.goBackWithParams(context, true);
                  }).catchError((err) {
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text("完成"))
        ],
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          hint != null ? Text(hint, textAlign: TextAlign.start,) : SizedBox(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child:
            TextField(
              maxLines: maxLines ?? 3,
              maxLength: limitWord ?? TextField.noMaxLength,
              controller: _controller,
            ),
          )
        ]),
      ),
    );
  }
}
