import 'package:json_annotation/json_annotation.dart';

part 'bubble.g.dart';

@JsonSerializable()
class Bubble {
  Bubble();
  int id;
  String nickname;
  String content;
  String tags;
  @JsonKey(name: "avatar_url")
  String avatarUrl;
  @JsonKey(name: "created_at")
  String createdAt;
  @JsonKey(name: "category_name")
  String categoryName;
  @JsonKey(name: "star_count")
  int startCount;
  @JsonKey(name: "comment_count")
  int commentCount;
  List<String> images;
  @JsonKey(name: "comment_url")
  String commentUrl;

  factory Bubble.fromJson(Map<String, dynamic> json) => _$BubbleFromJson(json);
  Map<String, dynamic> toJson() => _$BubbleToJson(this);
}
