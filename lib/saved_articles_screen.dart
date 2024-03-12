import 'package:flutter/material.dart';

import 'article_model.dart';
import 'detail_page.dart';

class SavedArticlesScreen extends StatelessWidget {
  final List<Article> savedArticles;

  const SavedArticlesScreen({Key? key, required this.savedArticles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save'),
      ),
      body: savedArticles.isEmpty
          ? const Center(child: Text('Chưa có bài báo nào được lưu!'))
          : ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(news: savedArticles[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          savedArticles[index].urlToImage,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        savedArticles[index].title,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
