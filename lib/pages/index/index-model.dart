import 'package:flutter_application/models/model.dart';

class Post {
  late int id;
  late int userId;
  late String content;
  late List<String> imageList;
  late List<String> videoList;
  late String createdAt;

  Post(this.id, this.userId, this.content, this.imageList, this.videoList, this.createdAt);

  Post.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    content = json["content"];
    imageList = List.from(json["imageList"]);
    videoList = List.from(json["videoList"]);
    createdAt = json["createdAt"];
  }
}

class SelectPostsResModel extends ResponseModel {
  late List<Post> data;
  late int totalCount;

  SelectPostsResModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = List.from(json['data']).map((post) => Post.fromJson(post)).toList();
    totalCount = json['totalCount'];
  }
}
