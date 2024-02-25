part of 'weather_bloc.dart';

@immutable
sealed class WeatherBlocEvent {}

class FetchWeatherByCity extends WeatherBlocEvent {
  String city;
  FetchWeatherByCity(this.city);
}
