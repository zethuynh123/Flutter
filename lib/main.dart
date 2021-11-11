import 'package:flutter/material.dart';
import 'package:flutter_news/services/implement/article_services.dart';
import 'package:flutter_news/ui/news_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.grey[300],
        primaryColor: Color(0xFF00A6E4),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red
        ),
      ),
      home: NewScreen(articleApi: ArticleServices()),
    );
  }
}
