

import 'package:weather_and_news_dashboard_app/features/news/data/data_sources/news_local_data_source.dart';
import 'package:weather_and_news_dashboard_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    required String category,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getTopHeadlines(
          category: category,
          page: page,
          pageSize: pageSize,
        );
        
        // Cache the articles
        await localDataSource.cacheArticles(remoteArticles);
        
        // Check bookmarks
        final articlesWithBookmarks = await _checkBookmarks(remoteArticles);
        
        return Right(articlesWithBookmarks);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localArticles = await localDataSource.getCachedArticles();
        return Right(localArticles);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.searchNews(
          query: query,
          page: page,
          pageSize: pageSize,
        );
        return Right(remoteArticles);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkArticle(Article article) async {
    try {
      await localDataSource.bookmarkArticle(article as ArticleModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getBookmarkedArticles() async {
    try {
      final bookmarks = await localDataSource.getBookmarkedArticles();
      return Right(bookmarks);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isArticleBookmarked(String url) async {
    try {
      final isBookmarked = await localDataSource.isArticleBookmarked(url);
      return Right(isBookmarked);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  Future<List<Article>> _checkBookmarks(List<ArticleModel> articles) async {
    final result = <Article>[];
    for (final article in articles) {
      final isBookmarked = await localDataSource.isArticleBookmarked(article.url);
      result.add(article.copyWith(isBookmarked: isBookmarked));
    }
    return result;
  }
}