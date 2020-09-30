import 'package:cheese_flutter/routes/timetable/page/course_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  String semester;
  int start;
  int length;
  int weekNumber;
  String className;
  String classAddress;
  String teacherName;
  int color;

  Course();

  Course.instance(
      {this.start,
      this.weekNumber,
      this.semester,
      this.length,
      this.classAddress,
      this.className,
      this.teacherName,
      this.color});

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
