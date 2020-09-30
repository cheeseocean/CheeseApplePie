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
  DateTime createdAt;
  DateTime updatedAt;


  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) {
   bool result = false;
   if(other is User){
     result = this.id == other.id &&
              this.username == other.username &&
              this.gender == other.gender &&
              this.location == other.location &&
              this.nickname == other.nickname &&
              this.avatarUrl == other.avatarUrl &&
              this.birth == other.birth &&
              this.email == other.email && this.bio == other.email && this.createdAt == other.createdAt;
   }
   return result;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
