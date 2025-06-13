import 'package:hive/hive.dart';
import 'package:weather_and_news_dashboard_app/features/weather/data/models/weather_model.dart';


abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weather);
  Future<WeatherModel> getLastWeather();
  Future<void> cacheForecast(List<WeatherModel> forecast);
  Future<List<WeatherModel>> getCachedForecast();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<WeatherModel> weatherBox;
  final Box<WeatherModel> forecastBox;

  WeatherLocalDataSourceImpl({
    required this.weatherBox,
    required this.forecastBox,
  });

  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    await weatherBox.put('current', weather);
  }

  @override
  Future<WeatherModel> getLastWeather() async {
    if (!weatherBox.containsKey('current')) {
      throw Exception('No cached weather found');
    }
    return weatherBox.get('current')!;
  }

  @override
  Future<void> cacheForecast(List<WeatherModel> forecast) async {
    await forecastBox.clear();
    await forecastBox.addAll(forecast);
  }

  @override
  Future<List<WeatherModel>> getCachedForecast() async {
    return forecastBox.values.toList();
  }
}