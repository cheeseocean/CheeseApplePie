import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  int id;
  String description;
  @JsonKey(name: "category_name")
  String categoryName;
  @JsonKey(name: "avatar_url")
  String avatarUrl;

  Category();


  factory Category.fromJson(Map<String,dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
