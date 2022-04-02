import 'dart:convert';
import 'package:flutter_application/http/http.dart';
import 'package:flutter_application/pages/creation/creation-model.dart';
import 'package:flutter_application/pages/creation/creation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SelectPostsResModel {
  late int id;
  late String username;
  late int userId;
  late PostContent content;
  late String contentType;
  late List<String> imageList;
  late List<String> videoList;
  late int likes;
  late int liked;
  late int comments;
  late String createdAt;
  late List<FileInfo> fileInfos;

  static List<SelectPostsResModel> toData(data) => List.from(data).map((e) => SelectPostsResModel.fromJson(e)).toList();

  SelectPostsResModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    username = json["username"];
    userId = json["userId"];
    content = PostContent.fromJson(jsonDecode(json["content"]));
    contentType = json["contentType"];
    imageList = List.from(json["imageList"]);
    videoList = List.from(json["videoList"]);
    likes = json["likes"];
    liked = json["liked"];
    comments = json["comments"];
    createdAt = json["createdAt"];
    fileInfos = [];
    Map<int, FileInfo> map = {};
    List types = [AssetType.image, AssetType.video];
    List assets = [imageList, videoList];
    for (int i = 0; i < assets.length; i++) {
      var list = assets[i];
      for (var image in list) {
        List<String> paths = image.split('=');
        map[int.parse(paths[1])] = FileInfo(type: types[i], path: 'http://$host:$port/' + paths.first.substring(0, paths.first.length - 2));
      }
    }
    for (int i = 0; i < imageList.length + videoList.length; i++) {
      fileInfos.add(map[i]!);
    }
  }
}

class LikePostResModal {
  late int type;

  static LikePostResModal toData(data) => LikePostResModal.fromJson(data);

  LikePostResModal.fromJson(Map<String, dynamic> json) {
    type = json["type"];
  }
}
