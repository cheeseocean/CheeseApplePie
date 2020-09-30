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
    ..avatarUrl = json['avatarUrl'] as String
    ..location = json['location'] as String
    ..bio = json['bio'] as String
    ..birth = json['birth'] as String
    ..gender = json['gender'] as int
    ..createdAt = DateTime.parse(json['createdAt'] as String);
    // ..updatedAt = DateTime.parse(json['updatedAt'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'location': instance.location,
      'bio': instance.bio,
      'birth': instance.birth,
      'gender': instance.gender,
      'createdAt': instance.createdAt.toIso8601String(),
      // 'updatedAt': instance.updatedAt,
    };
