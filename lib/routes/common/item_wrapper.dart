import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemWrapper extends StatelessWidget {
  final String avatar;
  final String name;
  final String date;
  final Widget action;
  final Widget content;
  final Widget bottomSpace;

  ItemWrapper({this.avatar, this.name, this.date, this.content, this.action,
      this.bottomSpace});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Align(
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: NetworkImage(avatar),
                        // child: Image.network(bubble.avatarUrl),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(name), Text(date)],
                  ),
                ),
                Expanded(flex: 2, child: action)
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: content,
          ),
          Expanded(flex: 2, child: bottomSpace),
        ],
      ),
    );
  }
}
