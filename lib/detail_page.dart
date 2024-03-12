import 'package:async_flutter/article_model.dart'; // Assuming Article model import
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final Article news;

  const DetailPage({super.key, required this.news});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getBool(widget.news.title) ?? false;
    });
  }

  Future<void> _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updatedIsLiked = !isLiked;

    // Lưu trạng thái đã thích mới vào SharedPreferences
    await prefs.setBool(widget.news.title, updatedIsLiked);

    // Cập nhật trạng thái đã thích của bài viết
    setState(() {
      isLiked = updatedIsLiked;
    });

    // Hiển thị thông báo Snackbar
    final snackBar = SnackBar(
      content: Text(
          updatedIsLiked ? 'Bài viết đã được lưu' : 'Bài viết đã được xóa'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Gọi hàm lưu bài viết đã thích hoặc xóa bài viết đã thích từ Localstore
    if (isLiked) {
      await saveArticles([widget.news]);
    } else {
      await deleteArticle([widget.news]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_rounded,
            ),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                widget.news.urlToImage,
                width: double.infinity,
                height: 190.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.news.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.news.content,
                style: const TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> saveArticles(List<Article> articles) async {
  final db = Localstore.instance;
  final likedArticles = await db.collection('users').doc('likedArticles').get();

  // Kiểm tra nếu likedArticles không null và có dữ liệu, sử dụng dữ liệu từ nó, nếu không, sử dụng một map rỗng
  // ignore: prefer_if_null_operators
  final savedArticles = likedArticles != null ? likedArticles : {};

  // Lưu các bài viết mới
  for (final article in articles) {
    if (!savedArticles.containsKey(article.title)) {
      savedArticles[article.title] = article.toMap();
    }
  }

  // Chuyển đổi kiểu dữ liệu của savedArticles sang Map<String, dynamic>
  final Map<String, dynamic> savedArticlesMap =
      Map<String, dynamic>.from(savedArticles);

  await db.collection('users').doc('likedArticles').set(savedArticlesMap);
}

Future deleteArticle(List<Article> articles) async {
  final db = Localstore.instance;
  return db.collection('users').doc('likedArticles').delete();
}
