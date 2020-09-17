import 'package:cheese_flutter/constants/extensions.dart';

class PageParameter {

  final String before;
  final String after;
  final num size;
  final num page;
  final List<String> sort;
  PageParameter(
      {String before, String after, this.size = 5, this.page = 0, this.sort})
      : this.before = before ?? DateTime.now().myToString(),
        this.after = after ?? new DateTime(1970).myToString();

  Map<String, String> toMap() {
    return {
      "before": before,
      "after": after,
      "size": size.toString(),
      "page": page.toString(),
    };
  }
}
