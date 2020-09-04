import 'package:json_annotation/json_annotation.dart';


part 'user.g.dart';

@JsonSerializable()
class User {
      User();

  int id;
  String username;
  String email;
  String nickname;
  @JsonKey(name: 'avatar_url') String avatarUrl;
  String location;
  String bio;
  String birth;
  int gender;
  @JsonKey(name: 'created_at') String createdAt;
  @JsonKey(name: 'updated_at') String updatedAt;

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
