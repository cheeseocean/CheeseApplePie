// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errorResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResult _$ErrorResultFromJson(Map<String, dynamic> json) {
  return ErrorResult()
    ..timestamp = json['timestamp'] as String
    ..status = json['status'] as String
    ..error = json['error'] as String
    ..message = json['message'] as String
    ..path = json['path'] as String;
}

Map<String, dynamic> _$ErrorResultToJson(ErrorResult instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'path': instance.path,
    };
