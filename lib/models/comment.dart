import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment{
  Comment();

  int id;
  String nickname;
  String username;

  String avatarUrl;

  DateTime createdAt;
  String content;

  int starCount;

  num parentId;

  num subCommentCount;
  
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}