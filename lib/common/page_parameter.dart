import 'package:cheese_flutter/constants/extensions.dart';

class PageParameter {

  final String end;
  final String start;
  final num size;
  final num page;
  final List<String> sort;
  PageParameter(
      {String start, String end, this.size = 5, this.page = 0, this.sort})
      : this.end = end ?? DateTime.now().myToString(),
        this.start = start ?? new DateTime(1970).myToString();

  Map<String, String> toMap() {
    return {
      "start": start,
      "end": end,
      "size": size.toString(),
      "page": page.toString(),
    };
  }
}
