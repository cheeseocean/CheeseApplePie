// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category()
    ..id = json['id'] as int
    ..description = json['description'] as String
    ..categoryName = json['categoryName'] as String
    ..avatarUrl = json['avatarUrl'] as String;
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'categoryName': instance.categoryName,
      'avatarUrl': instance.avatarUrl,
    };
