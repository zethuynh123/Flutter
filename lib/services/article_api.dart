import 'package:flutter_news/models/article.dart';

abstract class ArticleApi {
  Future<List<Article>> getListArticles(String topic);
}
