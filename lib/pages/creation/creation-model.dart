import 'package:flutter_application/models/model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// class CreatePostResModel extends ResponseModel {
//   CreatePostResModel({message, status, data}) : super(message: message, status: status, data: data);
//
//   factory CreatePostResModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel.fromJson(json) as CreatePostResModel;
//   }
// }

class UploadResModel extends ResponseModel {
  late List<String> data;

  UploadResModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = List.from(json['data']);
  }
}

class PostContentType {
  static const String normal = 'quill-normal';
  static const String rich = 'quill-rich';
}

class FileInfo {
  AssetEntity file;
  String path;

  FileInfo({required this.file, required this.path});
}

class QuillFileInfo {
  AssetType type;
  String path;

  QuillFileInfo({required this.type, required this.path});
}
