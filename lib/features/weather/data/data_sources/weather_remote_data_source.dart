import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_and_news_dashboard_app/core/constants/constants.dart';
import 'package:weather_and_news_dashboard_app/core/network/dio_client.dart';
import 'package:weather_and_news_dashboard_app/features/weather/data/models/weather_model.dart';


final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider);
  return WeatherRemoteDataSource(dio);
});

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<WeatherModel> getCurrentWeather(String query) async {
    try {
      final response = await dio.get(
        '/weather',
        queryParameters: {
          'q': query,
          'units': 'metric',
          'appid': Constants.weatherApiKey,
        },
      );
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load weather: ${e.message}');
    }
  }

  Future<List<WeatherModel>> getFiveDayForecast(String cityName) async {
    // TODO: Implement the actual API call and parsing logic
    throw UnimplementedError('getFiveDayForecast has not been implemented.');
  }
}