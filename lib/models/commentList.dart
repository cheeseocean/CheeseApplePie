

import 'package:cheese_flutter/models/pageable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';

part 'commentList.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentList extends PageableData{

  List<Comment> comments;

  CommentList();

  factory CommentList.fromJson(Map<String, dynamic> json) =>
      _$CommentListFromJson(json);
  Map<String, dynamic> toJson() => _$CommentListToJson(this);
}