
import 'package:cheese_flutter/models/pageable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'categoryList.g.dart';

@JsonSerializable()
class CategoryList extends PageableData {
  List<Category> content;

  CategoryList();
factory CategoryList.fromJson(Map<String, dynamic> json) =>
      _$CategoryListFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryListToJson(this);

}
