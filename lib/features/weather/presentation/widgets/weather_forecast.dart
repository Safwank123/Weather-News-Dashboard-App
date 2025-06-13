import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WeatherForecastWidget extends ConsumerWidget {
  const WeatherForecastWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastState = ref.watch(forecastProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (forecastState is ForecastLoading)
            const Center(child: CircularProgressIndicator()),
          if (forecastState is ForecastLoaded)
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecastState.forecast.length,
                itemBuilder: (context, index) {
                  final forecast = forecastState.forecast[index];
                  return ForecastItem(forecast: forecast);
                },
              ),
            ),
          if (forecastState is ForecastError)
            Text(
              forecastState.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
        ],
      ),
    );
  }
}

class ForecastItem extends StatelessWidget {
  final Forecast forecast;

  const ForecastItem({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            DateFormat.E().format(forecast.date),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Icon(
            _getWeatherIcon(forecast.condition),
            size: 24,
          ),
          Text(
            '${forecast.maxTemp.toStringAsFixed(0)}°/${forecast.minTemp.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}