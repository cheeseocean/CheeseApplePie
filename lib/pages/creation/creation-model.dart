import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// class CreatePostResModel extends ResponseModel {
//   CreatePostResModel({message, status, data}) : super(message: message, status: status, data: data);
//
//   factory CreatePostResModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel.fromJson(json) as CreatePostResModel;
//   }
// }

class PostContentType {
  static const String normal = 'quill-normal';
  static const String rich = 'quill-rich';
}

class FileInfo {
  AssetType type;
  AssetEntity? file;
  String path;

  FileInfo({required this.type, this.file, required this.path});
}
