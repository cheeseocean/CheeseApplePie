// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course()
    ..semester = json['semester'] as String
    ..start = json['start'] as int
    ..length = json['length'] as int
    ..weekNumber = json['weekNumber'] as int
    ..className = json['className'] as String
    ..classAddress = json['classAddress'] as String
    ..color = json['color'] as int
    ..teacherName = json['teacherName'] as String;
}

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'semester': instance.semester,
      'start': instance.start,
      'length': instance.length,
      'weekNumber': instance.weekNumber,
      'className': instance.className,
      'classAddress': instance.classAddress,
      'teacherName': instance.teacherName,
      'color': instance.color,
    };
