import 'package:cheese_flutter/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommentListItem extends StatelessWidget {
  final Comment comment;

  CommentListItem(this.comment);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
          onTap: () {
            print("tap comment");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    print("tag avatar");
                  },
                  child: CircleAvatar(child: Image.network(comment.avatarUrl)),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(comment.username),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(comment.createdAt),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(comment.content),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    print("star pressed");
                  },
                ),
              )
            ],
          )),
    );
  }
}
