import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_and_news_dashboard_app/core/constants/constants.dart';
import 'package:weather_and_news_dashboard_app/features/news/presentation/providers/news_provider.dart';
import 'package:weather_and_news_dashboard_app/features/weather/presentation/widgets/news_card.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(newsCategoryProvider);
    final newsAsync = ref.watch(topHeadlinesProvider(selectedCategory));

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context, ref),
          ),
        ],
      ),
      body: newsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No articles found'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(topHeadlinesProvider(selectedCategory).future),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return NewsCard(
                  article: article,
                  onBookmark: () => _toggleBookmark(ref, article),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _buildCategorySelector(ref),
    );
  }

  void _showSearch(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: NewsSearchDelegate(ref: ref),
    );
  }

  Future<void> _toggleBookmark(WidgetRef ref, Article article) async {
    final repository = ref.read(newsRepositoryProvider);
    await repository.bookmarkArticle(article);
    ref.invalidate(topHeadlinesProvider(article.category ?? 'general'));
  }

  BottomNavigationBar _buildCategorySelector(WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: Constants.newsCategories.indexOf(ref.watch(newsCategoryProvider)),
      onTap: (index) {
        ref.read(newsCategoryProvider.notifier).state = Constants.newsCategories[index];
      },
      items: Constants.newsCategories.map((category) {
        return BottomNavigationBarItem(
          icon: Icon(_getCategoryIcon(category)),
          label: category.capitalize(),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'business':
        return Icons.business;
      case 'technology':
        return Icons.computer;
      case 'sports':
        return Icons.sports;
      default:
        return Icons.article;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class NewsSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  NewsSearchDelegate({required this.ref});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ref.read(newsSearchProvider.notifier).searchNews(query);
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(newsSearchProvider);
        
        return state.when(
          initial: () => const Center(child: Text('Enter a search term')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (articles) {
            if (articles.isEmpty) {
              return const Center(child: Text('No results found'));
            }
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return NewsCard(
                  article: articles[index],
                  onBookmark: () => _toggleBookmark(ref, articles[index]),
                );
              },
            );
          },
          error: (message) => Center(child: Text(message)),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

  Future<void> _toggleBookmark(WidgetRef ref, Article article) async {
    final repository = ref.read(newsRepositoryProvider);
    await repository.bookmarkArticle(article);
    ref.invalidate(newsSearchProvider);
  }
}

final newsCategoryProvider = StateProvider<String>((ref) => 'business');