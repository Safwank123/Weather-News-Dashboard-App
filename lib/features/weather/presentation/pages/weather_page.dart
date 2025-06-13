import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_and_news_dashboard_app/features/weather/presentation/providers/weather_provider.dart';


class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CitySearchDelegate(ref: ref),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(weatherProvider.notifier).fetchWeather('current');
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (weatherState is WeatherLoaded)
                CurrentWeatherWidget(weather: weatherState.weather),
              const SizedBox(height: 16),
              const WeatherForecastWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  CitySearchDelegate({required this.ref});

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
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement city suggestions
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) => ListTile(
        title: Text('Suggestion $index'),
        onTap: () {
          query = 'Suggestion $index';
          showResults(context);
        },
      ),
    );
  }
}