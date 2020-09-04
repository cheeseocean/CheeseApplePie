import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class PageableData {
  PageableData();
  bool last;
  int totalPages;
  int totalElements;
  bool first;
  int size;
  int number;
  bool empty;
  Pageable pageable;
}

@JsonSerializable()
class Pageable {
  Pageable();
  int pageNumber;
  int pageSize;
  int offset;
  bool paged;

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);

  static Pageable _$PageableFromJson(Map<String, dynamic> json) {
    return Pageable()
      ..pageNumber = json['pageNumber'] as int
      ..pageSize = json['pageSize'] as int
      ..paged = json['paged'] as bool
      ..offset = json['offset'] as int;
  }

  Map<String, dynamic> _$PageableToJson(Pageable pageable) => <String, dynamic>{
        'pageNumber': pageable.pageNumber,
        'pageSize': pageable.pageSize,
        'offset': pageable.offset,
        'paged': pageable.paged
      };
}
