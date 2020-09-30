import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  int id;
  String username;
  String email;
  String nickname;
  String avatarUrl;
  String location;
  String bio;
  String birth;
  int gender;
  String createdAt;
  String updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
