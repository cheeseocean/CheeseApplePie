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
    ..avatarUrl = json['avatarUrl'] as String
    ..createdAt = json['createdAt'] as String
    ..content = json['content'] as String
    ..parentId = json['parentId'] as num
    ..subCommentCount = json['subCommentCount'] as num;
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt,
      'content': instance.content,
      'parentId': instance.parentId,
      'subCommentCount': instance.subCommentCount,
    };
