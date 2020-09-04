// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bubble.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bubble _$BubbleFromJson(Map<String, dynamic> json) {
  return Bubble()
    ..id = json['id'] as int
    ..nickname = json['nickname'] as String
    ..content = json['content'] as String
    ..tags = json['tags'] as String
    ..avatarUrl = json['avatar_url'] as String
    ..createdAt = json['created_at'] as String
    ..categoryName = json['category_name'] as String
    ..startCount = json['star_count'] as int
    ..commentCount = json['comment_count'] as int
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$BubbleToJson(Bubble instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'content': instance.content,
      'tags': instance.tags,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt,
      'category_name': instance.categoryName,
      'star_count': instance.startCount,
      'comment_count': instance.commentCount,
      'images': instance.images,
    };
