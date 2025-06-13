import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_and_news_dashboard_app/features/news/domain/repositories/news_repository.dart';


final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  throw UnimplementedError('NewsRepository should be overridden');
});

final topHeadlinesProvider = FutureProvider.family<List<Article>, String>((ref, category) async {
  final repository = ref.read(newsRepositoryProvider);
  final result = await repository.getTopHeadlines(category: category);
  return result.fold((l) => throw l, (r) => r);
});

final bookmarksProvider = FutureProvider<List<Article>>((ref) async {
  final repository = ref.read(newsRepositoryProvider);
  final result = await repository.getBookmarkedArticles();
  return result.fold((l) => throw l, (r) => r);
});

final newsSearchProvider = StateNotifierProvider<NewsSearchNotifier, NewsSearchState>((ref) {
  return NewsSearchNotifier(ref.read(newsRepositoryProvider));
});

class NewsSearchNotifier extends StateNotifier<NewsSearchState> {
  final NewsRepository repository;

  NewsSearchNotifier(this.repository) : super(NewsSearchInitial());

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      state = NewsSearchInitial();
      return;
    }

    state = NewsSearchLoading();
    try {
      final result = await repository.searchNews(query: query);
      state = result.fold(
        (failure) => NewsSearchError(failure.toString()),
        (articles) => NewsSearchLoaded(articles),
      );
    } catch (e) {
      state = NewsSearchError(e.toString());
    }
  }
}

abstract class NewsSearchState {}

class NewsSearchInitial extends NewsSearchState {}

class NewsSearchLoading extends NewsSearchState {}

class NewsSearchLoaded extends NewsSearchState {
  final List<Article> articles;

  NewsSearchLoaded(this.articles);
}

class NewsSearchError extends NewsSearchState {
  final String message;

  NewsSearchError(this.message);
}