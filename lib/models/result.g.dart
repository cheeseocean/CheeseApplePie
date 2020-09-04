// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result()
    ..status = json['status'] as int
    ..data = json['data'] as String;
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
