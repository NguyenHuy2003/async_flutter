import 'package:async_flutter/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const HomeScreen(),
        });
  }
}

//
// Lấy dữ liệu từ api
// Hiển thị lên màn hình
// Chưa lấy xong: hiện icon loadling
// Lấy xong hiện thị dữ liệu lên màn hình
