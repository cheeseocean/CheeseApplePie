import 'package:json_annotation/json_annotation.dart';

part 'bubble.g.dart';

@JsonSerializable()
class Bubble {
  Bubble();
  int id;
  String nickname;
  String content;
  String tags;
  String avatarUrl;
  DateTime createdAt;
  String categoryName;
  int starCount;
  int commentCount;
  List<String> imageUrls;
  String commentUrl;
  bool starred;

  factory Bubble.fromJson(Map<String, dynamic> json) => _$BubbleFromJson(json);
  Map<String, dynamic> toJson() => _$BubbleToJson(this);
}
