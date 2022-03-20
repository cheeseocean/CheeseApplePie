class ResponseModel {
  late String message;
  late num status;

  ResponseModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    status = json["status"];
  }
}
