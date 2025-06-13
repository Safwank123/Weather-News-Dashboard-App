import 'package:flutter_riverpod/flutter_riverpod.dart';


final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(weatherRepository);
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherNotifier(this.weatherRepository) : super(WeatherInitial());

  Future<void> fetchWeather(String cityName) async {
    state = WeatherLoading();
    try {
      final weather = await weatherRepository.getCurrentWeather(cityName);
      state = WeatherLoaded(weather: weather);
    } catch (e) {
      state = WeatherError(message: e.toString());
    }
  }
}