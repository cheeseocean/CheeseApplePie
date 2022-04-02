class ResponseModel<T> {
  late String message;
  late num status;
  T? data;
  int? totalCount;

  ResponseModel.fromJson(Map<String, dynamic> json, {Function(dynamic json)? toData}) {
    message = json["message"];
    status = json["status"];
    if (toData != null) data = toData(json["data"]) as T?;
    totalCount = json["totalCount"];
  }
}
