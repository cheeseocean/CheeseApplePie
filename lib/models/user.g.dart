// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..email = json['email'] as String
    ..nickname = json['nickname'] as String
    ..avatarUrl = json['avatar_url'] as String
    ..location = json['location'] as String
    ..bio = json['bio'] as String
    ..birth = json['birth'] as String
    ..gender = json['gender'] as int
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'location': instance.location,
      'bio': instance.bio,
      'birth': instance.birth,
      'gender': instance.gender,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
