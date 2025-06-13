import 'package:hive/hive.dart';
import 'package:weather_and_news_dashboard_app/features/weather/data/models/article_model.dart';


abstract class NewsLocalDataSource {
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> bookmarkArticle(ArticleModel article);
  Future<List<ArticleModel>> getBookmarkedArticles();
  Future<bool> isArticleBookmarked(String url);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box<ArticleModel> articlesBox;
  final Box<ArticleModel> bookmarksBox;

  NewsLocalDataSourceImpl({
    required this.articlesBox,
    required this.bookmarksBox,
  });

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    await articlesBox.clear();
    await articlesBox.addAll(articles);
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    return articlesBox.values.toList();
  }

  @override
  Future<void> bookmarkArticle(ArticleModel article) async {
    if (await isArticleBookmarked(article.url)) {
      await bookmarksBox.delete(article.url);
    } else {
      await bookmarksBox.put(article.url, article.copyWith(isBookmarked: true));
    }
  }

  @override
  Future<List<ArticleModel>> getBookmarkedArticles() async {
    return bookmarksBox.values.toList();
  }

  @override
  Future<bool> isArticleBookmarked(String url) async {
    return bookmarksBox.containsKey(url);
  }
}