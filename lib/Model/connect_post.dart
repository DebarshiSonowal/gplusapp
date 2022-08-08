
class ConnectPost{
  String? title,desc,tags,image;
  int? likes;
  List<ConnectPost>? comments;

  ConnectPost(
      this.title, this.desc, this.tags, this.image, this.likes, this.comments);
}