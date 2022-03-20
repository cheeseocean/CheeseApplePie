class PostListParams {
  int pageIndex;
  int pageSize;

  Map<String, dynamic> toJson() {
    return {
      "pageIndex": pageIndex,
      "pageSize": pageSize,
    };
  }

  PostListParams({this.pageIndex = 1, this.pageSize = 10});
}
