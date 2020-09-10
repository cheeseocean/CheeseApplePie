import 'package:cheese_flutter/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BubbleListItem extends StatelessWidget {
  final Bubble bubble;
  BubbleListItem({this.bubble});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 6, left: 6, right: 6),
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        height: 240,
        child: InkWell(
          focusColor: Colors.yellow,
          onTap: () {
            print("tap bubble");
            // showDialog(context: context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Align(
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage(bubble.avatarUrl),
                            // child: Image.network(bubble.avatarUrl),
                          ),
                        )),
                    Expanded(
                      flex: 8,
                      child:
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(bubble.nickname),
                          Text(bubble.createdAt)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          // padding: EdgeInsets.all(0.0),
                          child: Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            print("drop down");
                          }),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Text(
                    bubble.content,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Icon(Icons.comment),
                      onPressed: () {
                        print("comment");
                      },
                    ),
                    FlatButton(
                      child: Icon(Icons.star),
                      onPressed: () {
                        print("star");
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
