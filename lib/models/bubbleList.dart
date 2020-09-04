import 'package:cheese_flutter/models/pageable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bubble.dart';

part 'bubbleList.g.dart';

@JsonSerializable(explicitToJson: true)
class BubbleList extends PageableData {
  BubbleList();

  List<Bubble> content;

  factory BubbleList.fromJson(Map<String, dynamic> json) =>
      _$BubbleListFromJson(json);
  Map<String, dynamic> toJson() => _$BubbleListToJson(this);
}
