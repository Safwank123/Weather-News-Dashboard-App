class Constants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String newsApiUrl = 'https://newsapi.org/v2';
  static const String weatherApiKey = String.fromEnvironment('f9d0079d47bf17fe4d5f23400208da5d');
  static const String newsApiKey = String.fromEnvironment('49541740b52b4e83a0a5313016c2088d');
  
  static const List<String> newsCategories = [
    'business',
    'technology',
    'sports',
  ];
}