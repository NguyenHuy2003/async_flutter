import 'dart:convert';

import 'package:async_flutter/article_model.dart';
import 'package:async_flutter/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getArticles();
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: getArticles(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var news = snapshot.data as List<Article>;
                  return ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                news: news[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0.0,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                news[index].urlToImage,
                                width: 100.0,
                                height: 100.0,
                              ),
                            ),
                            // Adjust as desired

                            title: Text(
                              news[index].title,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Lỗi: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
            }
          },
        ));
  }

  Future<List<Article>> getArticles() async {
    const url =
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=393e2281d6b44ccda1a66b5f8a7e11b2';
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;

    final List<Article> result = [];
    for (final article in body['articles']) {
      result.add(
        Article(
          title: article['title'],
          urlToImage:
              article['urlToImage'] ?? 'https://via.placeholder.com/150',
          content: article['content'] ?? 'Không có dữ liệu',
        ),
      );
    }
    return result;
  }
}
