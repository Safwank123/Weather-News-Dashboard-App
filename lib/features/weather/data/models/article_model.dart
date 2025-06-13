import 'package:hive/hive.dart';
import 'package:weather_news_dashboard/features/news/domain/entities/article.dart';

part 'article_model.g.dart';

@HiveType(typeId: 1)
class ArticleModel extends Article {
  ArticleModel({
    required super.title,
    required super.description,
    required super.url,
    required super.urlToImage,
    required super.publishedAt,
    required super.source,
    required super.isBookmarked,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source']['name'] ?? '',
      isBookmarked: false,
    );
  }

  String get url => null;

  ArticleModel copyWith({required bool isBookmarked}) {}
}