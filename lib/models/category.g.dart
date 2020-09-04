// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category()
    ..id = json['id'] as int
    ..description = json['description'] as String
    ..categoryName = json['category_name'] as String
    ..avatarUrl = json['avatar_url'] as String;
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'category_name': instance.categoryName,
      'avatar_url': instance.avatarUrl,
    };
