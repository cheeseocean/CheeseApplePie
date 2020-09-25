import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment{
  Comment();

  int id;
  String nickname;
  String username;
  @JsonKey(name: "avatar_url")
  String avatarUrl;
  @JsonKey(name: "created_at")
  String createdAt;
  String content;
  @JsonKey(name: "parent_nickname")
  num parentId;
  @JsonKey(name: "sub_comment_count")
  num subCommentCount;
  
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}