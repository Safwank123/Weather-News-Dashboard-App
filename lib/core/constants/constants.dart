class Constants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String newsApiUrl = 'https://newsapi.org/v2';
  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const String newsApiKey = String.fromEnvironment('NEWS_API_KEY');
  
  static const List<String> newsCategories = [
    'business',
    'technology',
    'sports',
  ];
}