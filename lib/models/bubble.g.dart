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
    ..avatarUrl = json['avatarUrl'] as String
    ..createdAt = json['createdAt'] as String
    ..categoryName = json['categoryName'] as String
    ..startCount = json['startCount'] as int
    ..commentCount = json['commentCount'] as int
    ..imageUrls = (json['imageUrls'] as List)?.map((e) => e as String)?.toList()
    ..commentUrl = json['commentUrl'] as String
    ..starred = json['starred'] as bool;
}

Map<String, dynamic> _$BubbleToJson(Bubble instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'content': instance.content,
      'tags': instance.tags,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt,
      'categoryName': instance.categoryName,
      'startCount': instance.startCount,
      'commentCount': instance.commentCount,
      'imageUrls': instance.imageUrls,
      'commentUrl': instance.commentUrl,
      'starred': instance.starred,
    };
