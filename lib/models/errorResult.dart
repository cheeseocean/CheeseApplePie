import 'package:json_annotation/json_annotation.dart';

part 'errorResult.g.dart';

@JsonSerializable()
class ErrorResult{
  ErrorResult();
  String timestamp;
  String status;
  String error;
  String message;
  String path;
  factory ErrorResult.fromJson(Map<String,dynamic> json) => _$ErrorResultFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResultToJson(this);
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}