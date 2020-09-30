import 'package:cheese_flutter/constants/extensions.dart';

class PageParameter {

  final num end;
  final num start;
  final num size;
  final num page;
  final List<String> sort;
  PageParameter(
      {num start, num end, this.size = 5, this.page = 0, this.sort})
      : this.end = end ?? DateTime.now().millisecondsSinceEpoch,
        this.start = start ?? new DateTime(1970).millisecondsSinceEpoch;

  Map<String, String> toMap() {
    return {
      "start": start.toString(),
      "end": end.toString(),
      "size": size.toString(),
      "page": page.toString(),
    };
  }
}
