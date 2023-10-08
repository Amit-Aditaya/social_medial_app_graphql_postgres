class PostModel {
  final int id;
  final String title;
  final String content;
  final String author;
  final int createdAt;
  final String image;

  PostModel(this.id, this.title, this.content, this.author, this.createdAt,
      this.image);

  static PostModel fromMap(Map json) {
    return PostModel(
      json['id'],
      json['title'],
      json['content'],
      json['author'],
      json['createdAt'],
      json['image'],
    );
  }

  // Map toJson() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'content': content,
  //     'author': author,
  //     'createdAt': createdAt,
  //     'image': image,
  //   };
  // }
}
