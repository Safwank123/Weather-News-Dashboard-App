import 'package:weather_news_dashboard/core/errors/failures.dart';
import 'package:weather_news_dashboard/features/news/domain/entities/article.dart';
import 'package:dartz/dartz.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    required String category,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, void>> bookmarkArticle(Article article);
  
  Future<Either<Failure, List<Article>>> getBookmarkedArticles();
  
  Future<Either<Failure, bool>> isArticleBookmarked(String url);
}