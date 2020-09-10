// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment()
    ..id = json['id'] as int
    ..nickname = json['nickname'] as String
    ..username = json['username'] as String
    ..avatarUrl = json['avatar_url'] as String
    ..createdAt = json['created_at'] as String
    ..content = json['content'] as String
    ..parentId = json['parent_id'] as num
    ..subCommentCount = json['sub_comment_count'] as num;
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt,
      'content': instance.content,
      'parent_id': instance.parentId,
      'sub_comment_count': instance.subCommentCount,
    };
