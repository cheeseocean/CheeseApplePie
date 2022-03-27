import 'dart:convert';

import 'package:flutter_application/models/model.dart';
import 'package:flutter_application/pages/creation/creation.dart';

class Post {
  late int id;
  late String username;
  late int userId;
  late PostContent content;
  late List<String> imageList;
  late List<String> videoList;
  late int likes;
  late int comments;
  late String createdAt;

  Post(this.id, this.userId, this.username, this.content, this.imageList, this.videoList, this.likes, this.comments, this.createdAt);

  Post.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    username = json["username"];
    userId = json["userId"];
    content = PostContent.fromJson(jsonDecode(json["content"]));
    imageList = List.from(json["imageList"]);
    videoList = List.from(json["videoList"]);
    likes = json["likes"];
    comments = json["comments"];
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
