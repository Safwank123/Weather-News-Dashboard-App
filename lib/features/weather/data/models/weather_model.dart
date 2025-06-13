import 'package:hive/hive.dart';
import 'package:weather_news_dashboard/features/weather/domain/entities/weather.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends Weather {
  WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
    required super.iconCode,
    required super.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}