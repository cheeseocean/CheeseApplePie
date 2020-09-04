// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bubbleList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BubbleList _$BubbleListFromJson(Map<String, dynamic> json) {
  return BubbleList()
    ..last = json['last'] as bool
    ..totalPages = json['totalPages'] as int
    ..totalElements = json['totalElements'] as int
    ..first = json['first'] as bool
    ..size = json['size'] as int
    ..number = json['number'] as int
    ..empty = json['empty'] as bool
    ..pageable = json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>)
    ..content = (json['content'] as List)
        ?.map((e) =>
            e == null ? null : Bubble.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BubbleListToJson(BubbleList instance) =>
    <String, dynamic>{
      'last': instance.last,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'first': instance.first,
      'size': instance.size,
      'number': instance.number,
      'empty': instance.empty,
      'pageable': instance.pageable?.toJson(),
      'content': instance.content?.map((e) => e?.toJson())?.toList(),
    };
