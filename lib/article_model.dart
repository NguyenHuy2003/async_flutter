import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Article {
  String title;
  String urlToImage;
  String content;

  Article({
    required this.urlToImage,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'urlToImage': urlToImage,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] as String,
      urlToImage: map['urlToImage'] as String,
      content: map['content'] as String,
    );
  }
}
