import 'package:flutter_application/models/model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UploadResModel extends ResponseModel {
  late List<String> data;

  UploadResModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = List.from(json['data']);
  }
}

class PostContentType {
  static const String quillJson = 'quill-json';
  static const String normal = 'quill-normal';
  static const String rich = 'quill-rich';
}

class FileInfo {
  // AssetEntity file;
  String path;
  AssetType type;

  FileInfo({required this.type, required this.path});
}

class QuillFileInfo {
  AssetType type;
  String path;

  QuillFileInfo({required this.type, required this.path});
}

class PreviewData {
  List data;
  List<String> richPaths;
  String contentType;
  List<FileInfo> fileInfos;

  PreviewData(this.data, this.richPaths, this.contentType, this.fileInfos);
}
